class RemoveNullConstraintFromClaimReviewForMediaReview < ActiveRecord::Migration[7.0]
  def change
    change_column_null :claim_reviews, :media_review_id, true
  end
end
