class ClaimReview < ApplicationRecord
  validates :media_review_id, presence: true
  belongs_to :media_review, optional: true, class_name: "MediaReview"

  sig { returns(String) }
  def render_for_export
    ClaimReviewBlueprint.render(self)
  end
end
