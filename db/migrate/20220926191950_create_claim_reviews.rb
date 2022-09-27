class CreateClaimReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_reviews, id: :uuid do |t|
      t.timestamps
      t.datetime :date_published, null: false
      t.text :url, null: false
      t.jsonb :author, null: false
      t.text :claim_reviewed, null: false
      t.jsonb :review_rating
      t.jsonb :item_reviewed
      t.belongs_to :media_review, type: :uuid, primary_key: :media_review_id, foreign_key: :id
    end
  end
end
