class CreateUnifiedPosts < ActiveRecord::Migration[6.1]
  def change
    create_view :unified_posts
  end
end
