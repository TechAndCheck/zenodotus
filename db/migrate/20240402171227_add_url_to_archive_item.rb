class AddUrlToArchiveItem < ActiveRecord::Migration[7.0]
  def change
    add_column :archive_items, :url, :string
    add_index :archive_items, :url

    ArchiveItem.all.each do |archive_item|
      archive_item.update!(url: archive_item.archivable_item.url)
    end

    change_column_null :archive_items, :url, true
  end
end
