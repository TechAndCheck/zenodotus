class ChangeErrorDefaultOnScrape < ActiveRecord::Migration[7.0]
  def up
    Scrape.all.each { |s| s.update!({ error: false }) if s.error.nil? }
    change_column :scrapes, :error, :boolean, default: false, null: false
  end

  def down
    change_column :scrapes, :error, :boolean, default: nil
  end
end
