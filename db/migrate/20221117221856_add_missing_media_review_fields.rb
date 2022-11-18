class AddMissingMediaReviewFields < ActiveRecord::Migration[7.0]
  def change
    add_column :media_reviews, :start_time, :string
    add_column :media_reviews, :end_time, :string
  end
end
