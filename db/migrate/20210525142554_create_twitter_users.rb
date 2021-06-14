# typed: ignore

class CreateTwitterUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :twitter_users, id: :uuid do |t|
      t.string :handle, null: false
      t.string :display_name, null: false
      t.datetime :sign_up_date, null: false
      t.string :twitter_id, null: false
      t.text :description, null: false
      t.string :url, null: false
      t.text :profile_image_url, null: false
      t.string :location # Location may not be in the profile
      t.timestamps
    end
  end
end
