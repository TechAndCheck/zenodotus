class AddIndexesToViews < ActiveRecord::Migration[6.1]
  def change
    add_index :unified_users, :author_id, unique: true
    add_index :unified_posts, :post_id, unique: true
  end
end
