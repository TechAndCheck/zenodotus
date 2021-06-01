class CreateTwitterUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :twitter_users, id: :uuid do |t|
      t.string :handle
      t.string :display_name
      t.datetime :sign_up_date
      t.string :twitter_id
      t.text :description
      t.string :url
      t.string :profile_image_url
      t.string :location
      t.timestamps
    end
  end
end
