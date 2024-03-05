class CreateSourcesTikTokPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :tik_tok_posts, id: :uuid do |t|
      t.text "text", null: false
      t.string "tiktok_id", null: false
      t.datetime "posted_at", precision: nil, null: false
      t.integer "number_of_likes", null: false
      t.uuid "author_id", null: false
      t.index ["author_id"], name: "index_tiktok_posts_on_author_id"

      t.timestamps
    end
  end
end
