class Scrape < ApplicationRecord
  class MediaReviewItemNotFoundError < StandardError
    extend T::Sig

    attr_reader :url

    sig { params(url: String) }
    def initialize(url)
      @url = url
      super("Media review with url: #{url} for scrape fulfillment not found.")
    end
  end

  enum scrape_type: {
    twitter: "twitter", instagram: "instagram", facebook: "facebook", youtube: "youtube"
    }, _prefix: true

  has_one :archive_item, dependent: :destroy

  def fulfill(response)
    response = JSON.parse(response)

    archive_item = ArchiveItem.model_for_url(self.url).create_from_hash(response)

    # Update the previously created MediaReview item with the now archived stuff
    media_review_item = MediaReview.find_by(original_media_link: self.url, archive_item_id: nil, taken_down: nil)
    raise MediaReviewItemNotFoundError.new(self.url) if media_review_item.nil?

    if archive_item.empty?
      media_review_item.update!({ taken_down: true })
      self.update!({ fulfilled: true })
    else
      media_review_item.update({ archive_item_id: archive_item.first.id, taken_down: false })
      self.update!({ fulfilled: true, archive_item: archive_item.first })
    end
  end
end
