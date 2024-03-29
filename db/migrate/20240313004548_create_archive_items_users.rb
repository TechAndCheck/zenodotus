class CreateArchiveItemsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :archive_items_users, id: :uuid do |t|
      t.belongs_to :archive_item, type: :uuid, null: false, foreign_key: true
      t.belongs_to :user, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end

    add_index :archive_items_users, [:archive_item_id, :user_id], unique: true
  end
end
