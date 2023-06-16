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
    removed = false
    removed = true if response.empty? == false &&
                        response.first.key?("status") &&
                        response.first["status"] == "removed"

    # Process everything correctly now that we know it's not removed
    media_review_item = MediaReview.find_by(original_media_link: self.url,
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
end
