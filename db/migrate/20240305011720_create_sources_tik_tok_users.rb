class CreateSourcesTikTokUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :tik_tok_users, id: :uuid do |t|
      t.string "display_name", null: false
      t.string "handle", null: false
      t.integer "number_of_posts", null: false
      t.integer "followers_count", null: false
      t.integer "following_count", null: false
      t.boolean "verified", null: false
      t.text "profile", null: false
      t.string "url"
      t.string "profile_image_url", null: false
      t.jsonb "profile_image_data"
      t.timestamps
    end
  end
end
