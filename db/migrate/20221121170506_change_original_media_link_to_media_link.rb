class ChangeOriginalMediaLinkToMediaLink < ActiveRecord::Migration[7.0]
  def change
    # `original_media_link` already contains the data we actually want in `media_linek` so we rename
    # it and then recreate the same column for later.
    rename_column :media_reviews, :original_media_link, :media_link
  end
end
