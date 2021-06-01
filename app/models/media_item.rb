# typed: strict

class MediaItem < ApplicationRecord
  delegated_type :mediable, types: %w[ Tweet TwitterUser ]
  delegate :service_id, to: :mediable
end
