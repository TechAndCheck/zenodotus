class UpdateMediaReview < ActiveRecord::Migration[7.0]
  def change
    change_table :media_reviews do |t|
      t.remove :original_media_link
      t.datetime :date_published, null: false
      t.text :url, null: false
      t.jsonb :author, null: false
      t.jsonb :item_reviewed, null: false
    end
  end
end
