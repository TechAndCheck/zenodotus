# typed: ignore

class CreateInstagramVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :instagram_videos, id: :uuid do |t|
      t.references :instagram_post, type: :uuid, foreign_key: true
      t.jsonb      :video_data
      t.timestamps
    end
  end
end
