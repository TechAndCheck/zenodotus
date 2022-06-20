# typed: strict

class MediaReview < ApplicationRecord
  belongs_to :archive_item, optional: true, class_name: "ArchiveItem"

  # All media review without an attached piece of archive
  scope :orphaned, -> { where("archive_item_id = ?", nil) }

  sig { returns(Boolean) }
  def orphaned?
    archive_item.nil?
  end
end
