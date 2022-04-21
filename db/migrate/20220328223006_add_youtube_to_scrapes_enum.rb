class AddYoutubeToScrapesEnum < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TYPE scrape_type ADD VALUE 'youtube';
    SQL
  end
end
