class AddErrorToScrape < ActiveRecord::Migration[7.0]
  def change
    add_column :scrapes, :error, :boolean, default: nil
  end
end
