class ClaimReviewAuthor < ApplicationRecord
  has_many :claim_reviews, dependent: false
end
