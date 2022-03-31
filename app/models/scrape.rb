class Scrape < ApplicationRecord
  enum scrape_type: {
    twitter: "twitter", instagram: "instagram", facebook: "facebook", youtube: "youtube"
    }, _prefix: true

  has_one :archive_item, dependent: :destroy

  def fulfill(response)
    archive_item = case self.scrape_type
                   when "instagram"
                     Sources::InstagramPost.create_from_zorki_hash([response])
                   when "facebook"
                     Sources::FacebookPost.create_from_forki_hash([response])
    end

    self.update!({ fulfilled: true, archive_item: archive_item.first })
  end
end
