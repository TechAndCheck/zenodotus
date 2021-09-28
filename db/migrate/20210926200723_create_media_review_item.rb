class CreateMediaReviewItem < ActiveRecord::Migration[6.1]
  def change
    create_table :media_review_items, id: :uuid do |t|
      t.text :interpreted_as_claim
      t.belongs_to :media_review, type: :uuid, primary_key: :media_review_id, foreign_key: :id
    end
  end
end
