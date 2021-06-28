# typed: ignore

class CreateTwitterVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :twitter_videos, id: :uuid do |t|
      t.references :tweet, type: :uuid, foreign_key: true
      t.jsonb      :video_data
      t.timestamps
    end
  end
end
