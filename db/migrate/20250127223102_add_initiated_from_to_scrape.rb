class AddInitiatedFromToScrape < ActiveRecord::Migration[7.2]
  def change
    add_column :scrapes, :initiated_from, :integer
  end
end
