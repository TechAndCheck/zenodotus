class RenameScrapeArchiveIdToArchiveItemId < ActiveRecord::Migration[7.0]
  def change
    rename_column :scrapes, :archive_item, :archive_item_id
  end
end
