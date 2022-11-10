class AddExternalUniqueIdToClaimReviewAndMediaReview < ActiveRecord::Migration[7.0]
  def change
    add_column :claim_reviews, :external_unique_id, :uuid, index: true
    add_column :media_reviews, :external_unique_id, :uuid, index: true
  end
end
