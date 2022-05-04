class Scrape < ApplicationRecord
  enum scrape_type: {
    twitter: "twitter", instagram: "instagram", facebook: "facebook", youtube: "youtube"
    }, _prefix: true

  has_one :archive_item, dependent: :destroy

  def fulfill(response)
    response = JSON.parse(response)

    archive_item = ArchiveItem.model_for_url(self.url).create_from_hash(response)

    self.update!({ fulfilled: true, archive_item: archive_item.first })
  end
end
