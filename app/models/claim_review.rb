class ClaimReview < ApplicationRecord
  validates :media_review_id, presence: true
  belongs_to :media_review, optional: true, class_name: "MediaReview"

  def to_json
    ClaimReviewBlueprint.render(self)
  end
end
