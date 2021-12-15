class AddSubmitterToArchiveItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :archive_items, :submitter, index: true, type: :uuid
  end
end
