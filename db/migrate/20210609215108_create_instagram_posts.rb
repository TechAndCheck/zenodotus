# typed: ignore

class CreateInstagramPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :instagram_posts, id: :uuid do |t|
      t.text      :text, null: false
      t.string    :instagram_id, null: false
      t.datetime  :posted_at, null: false
      t.integer   :number_of_likes, null: false
      t.references :author, index: true, type: :uuid, null: false
      t.timestamps
    end

    create_table :instagram_images, id: :uuid do |t|
      t.references :instagram_post, type: :uuid, foreign_key: true
      t.jsonb      :image_data
      t.timestamps
    end
  end
end
