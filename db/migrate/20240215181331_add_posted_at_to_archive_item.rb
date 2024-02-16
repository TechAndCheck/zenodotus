class AddPostedAtToArchiveItem < ActiveRecord::Migration[7.0]
  def change
    add_column :archive_items, :posted_at, :datetime
  end
end
