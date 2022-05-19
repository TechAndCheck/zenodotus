class Scrape < ApplicationRecord
  enum scrape_type: {
    twitter: "twitter", instagram: "instagram", facebook: "facebook", youtube: "youtube"
    }, _prefix: true

  has_one :archive_item, dependent: :destroy

  def fulfill(response)
    response = JSON.parse(response)

    archive_item = ArchiveItem.model_for_url(self.url).create_from_hash(response)

    # Update the previously created MediaReview item with the now archived stuff
    media_review_item = MediaReview.find_by(original_media_link: self.url)
    media_review_item.update({ archive_item_id: archive_item.first.id }) unless media_review_item.nil?

    self.update!({ fulfilled: true, archive_item: archive_item.first })
  end
end
