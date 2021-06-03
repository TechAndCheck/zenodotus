class AddFollowersCountAndFollowingCountToTwitterUser < ActiveRecord::Migration[6.1]
  def change
    add_column :twitter_users, :followers_count, :integer
    add_column :twitter_users, :following_count, :integer
  end
end
