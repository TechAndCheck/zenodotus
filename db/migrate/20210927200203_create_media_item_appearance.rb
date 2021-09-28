class CreateMediaItemAppearance < ActiveRecord::Migration[6.1]
  def change
    create_table :media_item_appearances, id: :uuid do |t|
      t.text :_type
      t.text :description
      t.text :content_url
      t.text :archived_at

      t.belongs_to :media_review_item, type: :uuid, primary_key: :media_review_item_id, foreign_key: :id
    end
  end
end
