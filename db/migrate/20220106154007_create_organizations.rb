class CreateOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name, null: false
      t.references :admin, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
