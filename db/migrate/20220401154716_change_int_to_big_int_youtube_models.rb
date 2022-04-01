class ChangeIntToBigIntYoutubeModels < ActiveRecord::Migration[7.0]
  def change
    change_column :youtube_channels, :num_views, :bigint
    change_column :youtube_posts, :num_views, :bigint
    change_column :youtube_posts, :duration, :bigint
  end
end
