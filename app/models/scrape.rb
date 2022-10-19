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

  sig { void }
  def send_notification
    ActionCable.server.broadcast("scrapes_channel", { scrapes_count: Scrape.where(fulfilled: false, error: nil).count })
  end

  sig { params(response: Array).void }
  def fulfill(response)
    media_review_item = MediaReview.find_by(original_media_link: self.url, archive_item_id: nil, taken_down: nil)
    raise MediaReviewItemNotFoundError.new(self.url) if media_review_item.nil?

    begin
      # Mark removed if we're informed it no longer exists
      if response.empty? == false && response.first.key?("status") && response.first["status"] == "removed"
        self.update!({ fulfilled: true, removed: true })
        media_review_item.update!({ taken_down: true })
        return
      end
    rescue StandardError
      # debugger
    end

    archive_item = ArchiveItem.model_for_url(self.url).create_from_hash(response)

    # Update the previously created MediaReview item with the now archived stuff
    # if archive_item.empty?
    #   media_review_item.update!({ taken_down: true })
    #   self.update!({ fulfilled: true })
    # else
    media_review_item.update({ archive_item_id: archive_item.first.id, taken_down: false })
    self.update!({ fulfilled: true, archive_item: archive_item.first })
    # end
  end

  sig { void }
  def error
    self.update!({ error: true })
    self.send_notification
  end
end
