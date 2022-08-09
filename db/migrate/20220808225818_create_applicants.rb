class CreateApplicants < ActiveRecord::Migration[7.0]
  def change
    create_table :applicants, id: :uuid do |t|
      t.string   :name, null: false
      t.string   :email, null: false
      t.string   :affiliation
      t.string   :primary_role
      t.text     :use_case
      t.datetime :accepted_terms_at
      t.datetime :accepted_terms_version
      t.timestamps
    end
  end
end
