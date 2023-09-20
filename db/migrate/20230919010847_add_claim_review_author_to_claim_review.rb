class AddClaimReviewAuthorToClaimReview < ActiveRecord::Migration[7.0]
  def change
    add_reference :claim_reviews, :claim_review_author, type: :uuid
  end
end
