class CreateFactCheckOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :fact_check_organizations, id: :uuid do |t|
      t.string :name, null: false
      t.string :url, unique: true, null: false
      t.string :host_name, duplicate: false, null: false

      t.timestamps
    end

    drop_table :claim_review_authors
    remove_reference :claim_reviews, :claim_review_author

    add_reference :claim_reviews, :claim_review_author, type: :uuid, foreign_key: { to_table: :fact_check_organizations }
  end
end
