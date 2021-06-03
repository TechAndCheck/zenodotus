class AddProfileImageDataToTwitterUser < ActiveRecord::Migration[6.1]
  def change
    add_column :twitter_users, :profile_image_data, :jsonb
  end
end
