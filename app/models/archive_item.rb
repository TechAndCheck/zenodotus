# typed: true

class ArchiveItem < ApplicationRecord
  delegated_type :archivable_item, types: %w[ Tweet InstagramPost ]
  delegate :service_id, to: :archivable_item
end
