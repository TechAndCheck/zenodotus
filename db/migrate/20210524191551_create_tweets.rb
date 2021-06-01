# typed: true
class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets, id: :uuid do |t|
      t.text :text
      t.string :twitter_id
      t.string :language
    end
  end
end
