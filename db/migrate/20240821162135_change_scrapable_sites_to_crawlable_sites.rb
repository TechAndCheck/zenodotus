class ChangeScrapableSitesToCrawlableSites < ActiveRecord::Migration[7.0]
  def change
    rename_table :scrapable_sites, :crawlable_sites
  end
end
