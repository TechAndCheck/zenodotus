class Scrape < ApplicationRecord
  enum scrape_type: {
      twitter: "twitter", instagram: "instagram", facebook: "facebook"
    }, _prefix: true
end
