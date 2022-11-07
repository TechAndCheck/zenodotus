class AddMediaItemAppearanceToMediaReview < ActiveRecord::Migration[7.0]
  def change
    add_column :media_reviews, :media_item_appearance, :jsonb
  end
end
