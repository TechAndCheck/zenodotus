class CreateMediaReviewAuthor < ActiveRecord::Migration[6.1]
  def change
    create_table :media_review_authors, id: :uuid do |t|
      t.text :_type
      t.text :name
      t.text :url

      t.belongs_to :media_review, type: :uuid, primary_key: :media_review_id, foreign_key: :id
    end
  end
end
