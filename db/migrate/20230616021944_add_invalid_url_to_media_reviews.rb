class AddInvalidUrlToMediaReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :media_reviews, :invalid_url, :boolean, default: false, nil: false
  end
end
