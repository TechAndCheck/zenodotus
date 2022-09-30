class UpdateMediaReview < ActiveRecord::Migration[7.0]
  def change
    # original_media_context_description is occasionally null in the google feed
    change_column_null :media_reviews, :media_authenticity_category, true
    change_column_null :media_reviews, :original_media_context_description, true
    change_column_null :media_reviews, :original_media_link, true

    change_table :media_reviews do |t|
      t.jsonb :author
      t.datetime :date_published
      t.jsonb :item_reviewed
      t.text :url
    end
  end
end
