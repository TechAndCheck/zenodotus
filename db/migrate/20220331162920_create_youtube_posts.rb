class CreateYoutubePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_posts, id: :uuid do |t|
      t.string :title, null: false
      t.string :youtube_id, null: false
      t.integer :num_views, null: false
      t.integer :num_likes, null: false
      t.datetime :posted_at, null: false
      t.integer :duration, null: false
      t.boolean :live, null: false
      t.jsonb :preview_image, null: false
      t.integer :num_comments
      t.string :language
      t.string :channel_id
      t.timestamps
    end

    create_table :youtube_videos, id: :uuid do |t|
      t.references :youtube_post, type: :uuid, foreign_key: true
      t.jsonb :video_data
      t.timestamps
    end
  end
end
