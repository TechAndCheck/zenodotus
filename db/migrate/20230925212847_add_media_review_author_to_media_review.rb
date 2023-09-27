class AddMediaReviewAuthorToMediaReview < ActiveRecord::Migration[7.0]
  def change
    add_reference :media_reviews, :media_review_author, type: :uuid, foreign_key: { to_table: :fact_check_organizations }
  end
end
