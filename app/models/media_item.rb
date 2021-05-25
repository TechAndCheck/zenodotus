# typed: strict

class MediaItem < ApplicationRecord
  delegated_type :entryable, types: %w[ Tweet ]
end
