# typed: false

class ArchiveItem < ApplicationRecord
  delegated_type :archivable_item, types: %w[ Tweet ]
  delegate :service_id, to: :archivable_item
end
