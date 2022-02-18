class AddUserToImageSearches < ActiveRecord::Migration[6.1]
  def change
    add_reference :image_searches, :submitter, index: true, type: :uuid
  end
end
