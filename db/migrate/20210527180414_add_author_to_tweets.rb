# typed: ignore

class AddAuthorToTweets < ActiveRecord::Migration[6.1]
  def change
    add_reference :tweets, :author, index: true, type: :uuid, null: false
  end
end
