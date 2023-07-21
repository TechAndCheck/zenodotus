class AddCreationDateToTweet < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :created_at, :datetime, null: false
    add_column :tweets, :updated_at, :datetime, null: false
  end
end
