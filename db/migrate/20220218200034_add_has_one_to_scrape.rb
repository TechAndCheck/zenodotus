class AddHasOneToScrape < ActiveRecord::Migration[7.0]
  def change
    remove_column :scrapes, :archive_item_id
    add_column :archive_items, :scrape_id, :uuid
  end
end
