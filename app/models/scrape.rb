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
    twitter: "twitter", instagram: "instagram", facebook: "facebook", youtube: "youtube", tiktok: "tiktok"
    }, _prefix: true

  has_one :archive_item, dependent: :destroy
  belongs_to :media_review, dependent: nil, optional: true
  belongs_to :user, optional: true

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
        logger.info("Marking: #{self.url} as removed. 🦕")
        # The url is not valid, so we should mark it as removed
        self.fulfill([{ status: "removed" }])
        # We don't raise because we don't want it to retry.
      else
        self.mark_error
        raise Scrape::ExternalServerError.new("Error: #{response.code} returned from Hypatia server.")
      end
    end

    JSON.parse(response.body)
  end

  sig { void }
  def send_notification
    ActionCable.server.broadcast("scrapes_channel", { scrapes_count: Scrape.where(fulfilled: false, error: nil).count })
  end

  sig { void }
  def send_completion_email
    if self.user.present?
      if self.removed
        ScrapeMailer.with(url: self.url, user: self.user).scrape_removed_email.deliver_later
      elsif self.error
        ScrapeMailer.with(url: self.url, user: self.user).scrape_error_email.deliver_later
      else
        ScrapeMailer.with(url: self.url, user: self.user).scrape_complete_email.deliver_later
      end
    end
  end

  sig { params(response: Array).void }
  def fulfill(response)
    logger.info "\n*******************************"
    logger.info "Processing Fulfill Response"
    logger.info "---------------------------"
    logger.info "URL: #{self.url}"
    logger.info "Response: #{response}"
    logger.info "*******************************\n"

    removed = false
    errored = false

    if response.empty? == false && response.first.has_key?("status") # `status` isn't returned if it's successful, should consider fixing that at some point
      case response.first["status"]
      when "removed"
        logger.info "----------------------------------"
        logger.info "Post removed at #{self.url}"
        logger.info "----------------------------------"

        removed = true
      when "error"
        logger.info "----------------------------------"
        logger.info "Post Errored at #{self.url}"
        logger.info "----------------------------------"

        errored = true
      else
        logger.info "----------------------------------"
        logger.info "Post Errored at #{self.url}"
        logger.info "----------------------------------"

        errored = true # For later in case the option for `status` could be something else
      end
    end

    # Process everything correctly now that we know it's not removed
    media_review_item = self.media_review
    media_review_item = MediaReview.find_by(media_url: self.url,
                                            archive_item_id: nil,
                                            taken_down: nil) if media_review_item.nil?

    unless removed || errored
      archive_item = ArchiveItem.model_for_url(self.url).create_from_hash(response, self.user)
      archive_item = archive_item.empty? ? nil : archive_item.first

      # Add a user to the archive_item if we have a user
      archive_item.users << self.user if archive_item.present? && self.user.present?
    end

    unless media_review_item.nil?
      media_review_item.update!({ taken_down: removed, archive_item_id: archive_item&.id })
    end

    self.update!({ fulfilled: true, removed: removed, archive_item: archive_item, error: errored })

    # Update any channels listening to the scrape count
    self.send_notification

    # Send the completion email or whatever if necessary
    self.send_completion_email
  rescue StandardError => e
    Honeybadger.notify(e, context: {
      id: self.id,
      url: self.url,
      response: response
    })
  end

  sig { void }
  def mark_error
    self.update!({ error: true })
    self.send_notification
  end

  class Scrape::ExternalServerError < StandardError; end
end
