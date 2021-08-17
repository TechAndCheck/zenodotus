class CreateTextSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :text_searches, id: :uuid do |t|
      t.string :query, nil: false
      t.string :user_id
      t.timestamps
    end
  end
end
