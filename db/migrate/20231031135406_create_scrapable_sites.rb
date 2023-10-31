class CreateScrapableSites < ActiveRecord::Migration[7.0]
  def change
    create_table :scrapable_sites, id: :uuid do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :starting_url
      t.datetime :last_run, default: nil
      t.timestamps
    end
  end
end
