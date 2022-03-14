class AddUserForeignKeyToTextSearches < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :text_searches, :users, column: :user_id
  end
end
