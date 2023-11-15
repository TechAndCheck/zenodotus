class AddRunTimeAndNumberFoundToScrapableSite < ActiveRecord::Migration[7.0]
  def change
    add_column :scrapable_sites, :last_run_time, :integer, defualt: nil
    add_column :scrapable_sites, :number_of_claims_found, :integer, default: 0, null: false
  end
end
