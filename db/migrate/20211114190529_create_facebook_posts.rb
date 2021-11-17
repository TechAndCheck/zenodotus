class CreateFacebookPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :facebook_posts, id: :uuid do |t|
      t.datetime :posted_at
      t.text :text
      t.text :facebook_id
      t.references :author, index: true, type: :uuid, null: false
      t.jsonb :reactions
      t.integer :num_comments
      t.integer :num_shares
      t.integer :num_views
      t.timestamps
      t.text :url, null: false
    end
  end
end
