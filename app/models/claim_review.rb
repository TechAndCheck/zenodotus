class ClaimReview < ApplicationRecord
  belongs_to :media_review, optional: true, class_name: "MediaReview"
end
