# typed: true

class ArchiveEntity < ApplicationRecord
  delegated_type :archivable_entity, types: %w[ TwitterUser InstagramUser]
  delegate :service_id, to: :archivable_entity
end
