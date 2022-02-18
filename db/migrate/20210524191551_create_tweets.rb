# typed: ignore
# rubocop:disable Rails/CreateTableWithTimestamps

class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets, id: :uuid do |t|
      t.text :text, null: false
      t.string :twitter_id, null: false
      t.string :language, null: false
    end
  end
end
