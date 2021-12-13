class CreateFacebookUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :facebook_users, id: :uuid do |t|
      t.string :facebook_id
      t.string :name
      t.boolean :verified
      t.integer :followers_count
      t.integer :likes_count
      t.string :url
      t.jsonb :profile_image_data
      t.string :profile_image_url
      t.timestamps
    end
  end
end
