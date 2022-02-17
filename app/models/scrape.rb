class Scrape < ApplicationRecord
  enum scrape_type: {
      twitter: "twitter", instagram: "instagram", facebook: "facebook"
    }, _prefix: true

  belongs_to :archive_item, optional: true

  def fulfill(response)
    archive_item = case self.scrape_type
                   when "instagram"
                     Sources::InstagramPost.create_from_zorki_hash([response])
                   when "facebook"
                     Sources::InstagramPost.create_from_forki_hash([response])
    end

    self.update!({ fulfilled: true, archive_item: archive_item.first })
  end
end
