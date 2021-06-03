class AddPostedAtToTweets < ActiveRecord::Migration[6.1]
  def change
    add_column :tweets, :posted_at, :datetime
  end
end
