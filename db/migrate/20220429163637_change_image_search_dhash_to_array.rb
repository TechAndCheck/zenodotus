class ChangeImageSearchDhashToArray < ActiveRecord::Migration[7.0]
  def up
    remove_column :image_searches, :dhash
    add_column :image_searches, :dhashes, :jsonb, array: true
  end

  def down
    remove_column :image_searches, :dhashes
    add_column :image_searches, :dhash, :string
  end
end
