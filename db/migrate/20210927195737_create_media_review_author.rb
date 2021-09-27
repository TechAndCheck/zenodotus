class CreateMediaReviewAuthor < ActiveRecord::Migration[6.1]
  def change
    create_table :media_review_authors, id: :uuid do |t|
      t.text :type
      t.text :name
      t.text :url
    end
  end
end
