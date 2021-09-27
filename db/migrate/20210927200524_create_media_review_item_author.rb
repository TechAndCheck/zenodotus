class CreateMediaReviewItemAuthor < ActiveRecord::Migration[6.1]
  def change
    create_table :media_review_item_authors, id: :uuid do |t|
      t.text :type
      t.text :name
      t.text :url

      t.belongs_to :media_review_item, type: :uuid, primary_key: :media_review_item_id, foreign_key: :id
    end
  end
end
