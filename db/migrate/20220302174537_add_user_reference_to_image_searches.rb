class AddUserReferenceToImageSearches < ActiveRecord::Migration[7.0]
  def change
    add_reference :image_searches, :user, index: true, type: :uuid, foreign_key: true
  end
end
