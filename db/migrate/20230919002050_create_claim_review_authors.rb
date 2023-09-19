class CreateClaimReviewAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_review_authors, id: :uuid do |t|
      t.string :name, null: false, unique: true
      t.string :url, null: false, unique: true

      t.timestamps
    end
  end
end
