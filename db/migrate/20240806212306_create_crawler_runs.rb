class CreateCrawlerRuns < ActiveRecord::Migration[7.0]
  def change
    create_table :crawler_runs, id: :uuid do |t|
      t.string :starting_url, null: false, unique: true
      t.string :host_name, null: false, unique: true
      t.timestamp :started_at
      t.timestamp :finished_at
      t.integer :number_of_pages_scraped, default: 0, null: false
      t.integer :number_of_new_claims_found, default: 0, null: false
      t.timestamps
    end
  end
end
