class AddPublicIdToArchiveItem < ActiveRecord::Migration[7.0]
  def change
    add_column :archive_items, :public_id, :string
    add_index :archive_items, :public_id, unique: true

    ArchiveItem.all.each do |item|
      item.update_columns(public_id: SecureRandom.uuid) # We don't use the function becuase it messed up the dev environment'
    end

    change_column_null :archive_items, :public_id, false
  end
end
