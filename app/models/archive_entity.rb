# typed: true

class ArchiveEntity < ApplicationRecord
  delegated_type :archivable_entity, types: %w[ TwitterUser ]
  delegate :service_id, to: :archivable_entity
end
