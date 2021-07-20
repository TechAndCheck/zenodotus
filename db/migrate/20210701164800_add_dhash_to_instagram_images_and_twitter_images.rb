# typed: ignore

class AddDhashToInstagramImagesAndTwitterImages < ActiveRecord::Migration[6.1]
  def change
    add_column :instagram_images, :dhash, :string
    add_column :twitter_images, :dhash, :string
  end
end
