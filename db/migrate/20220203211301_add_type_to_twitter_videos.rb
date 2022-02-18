class AddTypeToTwitterVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_videos, :video_type, :text
  end
end
