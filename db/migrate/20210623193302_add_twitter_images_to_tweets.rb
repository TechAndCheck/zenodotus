# typed: ignore

class AddTwitterImagesToTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :twitter_images, id: :uuid do |t|
      t.references :tweet, type: :uuid, foreign_key: true
      t.jsonb      :image_data
      t.timestamps
    end
  end
end
