class AddDatePublishedToMediaReview < ActiveRecord::Migration[6.1]
  def change
    add_column :media_reviews, :date_published, :datetime
  end
end
