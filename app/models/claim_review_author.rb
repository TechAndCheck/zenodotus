class ClaimReviewAuthor < ApplicationRecord
  has_many :claim_reviews, dependent: false

  before_save do
    self.url = "" if self.url.nil?
    self.name = self.url if self.name.nil?
  end
end
