class AddPrivateFlagToArchiveItem < ActiveRecord::Migration[7.0]
  def change
    add_column :archive_items, :private, :boolean, default: false, null: false
  end
end
