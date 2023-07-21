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
  sig { void }
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

    unless response.code == 200
      self.error
      exception = Scrape::ExternalServerError.new("Error: #{response.code} returned from Hypatia server.")
      Honeybadger.notify(exception, context: {
        response_body: response.body
      }) unless Figaro.env.HONEYBADGER_API_KEY.blank?

      raise exception
    end

    JSON.parse(response.body)
  end

  sig { void }
  def send_notification
    ActionCable.server.broadcast("scrapes_channel", { scrapes_count: Scrape.where(fulfilled: false, error: nil).count })
  end

  sig { params(response: Array).void }
  def fulfill(response)
    removed = false
    removed = true if response.empty? == false &&
                        response.first.key?("status") &&
                        response.first["status"] == "removed"

    # Process everything correctly now that we know it's not removed
    media_review_item = MediaReview.find_by(media_url: self.url,
                                            archive_item_id: nil,
                                            taken_down: nil)

    unless removed
      archive_item = ArchiveItem.model_for_url(self.url).create_from_hash(response)
      archive_item = archive_item.empty? ? nil : archive_item.first
    end

    unless media_review_item.nil?
      media_review_item.update!({ taken_down: removed, archive_item_id: archive_item&.id })
    end

    self.update!({ fulfilled: true, removed: removed, archive_item: archive_item })

    # Update any channels listening to the scrape count
    send_notification
  end

  sig { void }
  def error
    self.update!({ error: true })
    self.send_notification
  end

  class Scrape::ExternalServerError < StandardError; end
end
