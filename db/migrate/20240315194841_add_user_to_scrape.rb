class AddUserToScrape < ActiveRecord::Migration[7.0]
  def change
    add_column :scrapes, :user_id, :uuid, default: nil, null: true
  end
end
