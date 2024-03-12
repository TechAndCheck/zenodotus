class AddTiktokScrapeTypeEnum < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TYPE scrape_type ADD VALUE IF NOT EXISTS 'tiktok';
    SQL
  end
end
