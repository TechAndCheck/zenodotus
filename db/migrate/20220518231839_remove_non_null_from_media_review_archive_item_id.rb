class RemoveNonNullFromMediaReviewArchiveItemId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :media_reviews, :archive_item_id, true
  end
end
