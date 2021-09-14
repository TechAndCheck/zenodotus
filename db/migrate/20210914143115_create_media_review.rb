class CreateMediaReview < ActiveRecord::Migration[6.1]
  def change
    create_table :media_review, id: :uuid do |t|
      t.timestamps
      t.text :original_media_link, null: false
      t.text :media_authenticity_category, null: false
      t.text :original_media_context_description, null: false
      t.belongs_to :archive_item, type: :uuid, foreign_key: true
      # has_one claimreview?
    end
  end
end
