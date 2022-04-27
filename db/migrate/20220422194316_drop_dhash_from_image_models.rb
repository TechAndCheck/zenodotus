class DropDhashFromImageModels < ActiveRecord::Migration[7.0]
  def change
    remove_column :instagram_images, :dhash
    remove_column :twitter_images, :dhash
    remove_column :facebook_images, :dhash
  end
end
