# typed: true

class ArchiveItem < ApplicationRecord
  delegated_type :archivable_item, types: %w[ Tweet InstagramPost ]
  delegate :service_id, to: :archivable_item

  # Creates an +ArchiveEntity
  #
  # @!scope class
  # @params media_review String a block of json media_review
  # @return a Boolean on whether or not the class can handle the URL
  def self.create_from_media_review(media_review)
  end
end
