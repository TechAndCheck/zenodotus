class CreateScrapes < ActiveRecord::Migration[7.0]
  def change
    create_enum :scrape_type, ["instagram", "facebook", "twitter"]

    create_table :scrapes, id: :uuid do |t|
      t.boolean :fulfilled, null: false, default: false
      t.string :url, null: false
      t.enum :scrape_type, enum_type: :scrape_type, null: false
      t.uuid :archive_item
      t.timestamps
    end
  end
end
