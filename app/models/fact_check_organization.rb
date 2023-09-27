class FactCheckOrganization < ApplicationRecord
  validates :url, uniqueness: true
  has_many :media_reviews, foreign_key: :media_review_author, dependent: :destroy
  has_many :claim_reviews, foreign_key: :claim_review_author, dependent: :destroy
  has_many :archive_items, through: :media_reviews, dependent: :destroy

  before_save do
    self.host_name = URI.parse(self.url).host
  end
end
