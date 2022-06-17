class AddTakenDownToMediaReview < ActiveRecord::Migration[7.0]
  def change
    add_column :media_reviews, :taken_down, :boolean, null: true, default: nil
  end
end
