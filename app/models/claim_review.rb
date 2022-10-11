class ClaimReview < ApplicationRecord
  validates :media_review_id, presence: true
  belongs_to :media_review, optional: true, class_name: "MediaReview"
end
