class AddMediaUrlToMediaReview < ActiveRecord::Migration[7.0]
  def change
    add_column :media_reviews, :media_url, :string, nil: false
  end
end
