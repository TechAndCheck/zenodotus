class CreateClaimReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_reviews, id: :uuid do |t|
      t.timestamps
      t.text :claim_reviewed
      t.text :url
      t.jsonb :author
      t.datetime :date_published
      t.jsonb :item_reviewed
      t.jsonb :review_rating

      t.belongs_to :media_review, type: :uuid, primary_key: :media_review_id, foreign_key: :id
    end
  end
end
