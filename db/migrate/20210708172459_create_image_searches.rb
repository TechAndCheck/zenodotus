# typed: ignore

class CreateImageSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :image_searches, id: :uuid do |t|
      t.string :dhash, nil: false
      t.jsonb  :image_data, nil: false
      t.timestamps
    end
  end
end
