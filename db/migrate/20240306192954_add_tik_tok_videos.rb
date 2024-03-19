class AddTikTokVideos < ActiveRecord::Migration[7.0]
  def change
    create_table "tik_tok_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "tik_tok_post_id"
      t.jsonb "video_data"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["tik_tok_post_id"], name: "index_tik_tok_videos_on_instagram_post_id"
    end
  end
end
