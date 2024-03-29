class ChangeTiktokIdToTikTokId < ActiveRecord::Migration[7.0]
  def change
    if column_exists? :tik_tok_posts, :tiktok_id
      rename_column :tik_tok_posts, :tiktok_id, :tik_tok_id
    end
  end
end
