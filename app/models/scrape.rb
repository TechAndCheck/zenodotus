class Scrape < ApplicationRecord
  class MediaReviewItemNotFoundError < StandardError
    extend T::Sig

    attr_reader :url

    sig { params(url: String).void }
    def initialize(url)
      @url = url
      super("Media review with url: #{url} for scrape fulfillment not found.")
    end
  end

  enum scrape_type: {
    twitter: "twitter", instagram: "instagram", facebook: "facebook", youtube: "youtube"
    }, _prefix: true

  has_one :archive_item, dependent: :destroy

  after_create :send_notification

  # Enqueue the scraping callout to Hypatia into the ActiveJob queue
  # TODO: Eventually this should be the main interface to kicking it off, but for now... no
  sig { returns(ScrapeJob) }
  def enqueue
    ScrapeJob.perform_later(self)
  end

  # Make the call to Hypatia, the return should be { success: "true" } after parsing
  # This does it synchronously. If you're calling this you probably mean to call `enqueue`
  sig { returns(Hash) }
  def perform
    params = { auth_key: Figaro.env.HYPATIA_AUTH_KEY, url: self.url, callback_id: self.id }

    # Move this to the Scrape model so they're easily resubmittable
    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    json_error_response = JSON.parse(response.body)
    if response.code != 200
      if response.code == 400 && json_error_response.nil? == false && json_error_response["code"] == 10
        logger.debug("Marking: #{self.url} as removed. 🦕")
        # The url is not valid, so we should mark it as removed
        self.fulfill([{ status: "removed" }])
        # We don't raise because we don't want it to retry.
      else
        self.error
        raise Scrape::ExternalServerError.new("Error: #{response.code} returned from Hypatia server.")
      end
    end

    JSON.parse(response.body)
  end

  sig { void }
  def send_notification
    ActionCable.server.broadcast("scrapes_channel", { scrapes_count: Scrape.where(fulfilled: false, error: nil).count })
  end

  sig { params(response: Array).void }
  def fulfill(response)
    logger.debug "\n*******************************"
    logger.debug "Processing Fulfill Response"
    logger.debug "---------------------------"
    logger.debug "URL: #{self.url}"
    logger.debug "Response: #{response}"
    logger.debug "*******************************\n"

    removed = false
    errored = false

    if response.empty? == false && response.first.has_key?("status") # `status` isn't returned if it's successful, should consider fixing that at some point
      case response.first["status"]
      when "removed"
        removed = true
      when "error"
        errored = true
      else
        errored = true # For later in case the option for `status` could be something else
      end
    end

    # Process everything correctly now that we know it's not removed
    media_review_item = MediaReview.find_by(media_url: self.url,
                                            archive_item_id: nil,
                                            taken_down: nil)

    unless removed || errored
      archive_item = ArchiveItem.model_for_url(self.url).create_from_hash(response)
      archive_item = archive_item.empty? ? nil : archive_item.first
    end

    unless media_review_item.nil?
      media_review_item.update!({ taken_down: removed, archive_item_id: archive_item&.id })
    end

    self.update!({ fulfilled: true, removed: removed, archive_item: archive_item, error: errored })

    # Update any channels listening to the scrape count
    self.send_notification
  rescue StandardError => e
    Honeybadger.notify(e, context: {
      response: response
    })
  end

  # sig { void }
  # def error
  #   self.update!({ error: true })
  #   self.send_notification
  # end

  class Scrape::ExternalServerError < StandardError; end
end
