class RemovePreviewImageFromYoutubePosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :youtube_posts, :preview_image_data
  end
end
