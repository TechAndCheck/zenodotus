# typed: ignore

class AddMediaReviewToArchiveItem < ActiveRecord::Migration[6.1]
  def change
    add_column :archive_items, :media_review, :jsonb
  end
end
