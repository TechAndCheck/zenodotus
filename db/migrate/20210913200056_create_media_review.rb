class CreateMediaReview < ActiveRecord::Migration[6.1]
  def change
    create_table :media_review, id: :uuid do |t|
      t.timestamps
      t.text :link, null: false
      t.text :authenticity, null: false
      t.text :context, null: false
      t.belongs_to :archive_item, type: :uuid, foreign_key: true
      # has_one claimreview?
    end
  end
end
