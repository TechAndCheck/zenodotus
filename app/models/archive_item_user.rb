class ArchiveItemUser < ApplicationRecord
  self.table_name = "archive_items_users"

  belongs_to :archive_item
  belongs_to :user
end
