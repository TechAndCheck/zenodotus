class AddOriginalMediaReviewToMediaReview < ActiveRecord::Migration[7.0]
  def change
    add_column :media_reviews, :original_media_review, :string, nil: false
  end
end
