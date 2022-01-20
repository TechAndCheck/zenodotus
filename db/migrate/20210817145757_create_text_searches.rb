class CreateTextSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :text_searches, id: :uuid do |t|
      t.timestamps
      t.string :query, nil: false
      t.belongs_to :user, type: :uuid
    end
  end
end
