class CreateMediaReview < ActiveRecord::Migration[6.1]
  def change
    create_table :media_reviews, id: :uuid do |t|
      t.timestamps
      t.text :original_media_link, null: false
      t.text :media_authenticity_category, null: false
      t.text :original_media_context_description, null: false
      # t.belongs_to :tweet, type: :uuid, foreign_key: true
      # t.belongs_to :instagram_post, type: :uuid, foreign_key: true
      t.belongs_to :archive_item, type: :uuid, primary_key: :archive_item_id, foreign_key: :id
      # has_one claimreview?
    end
  end
end
