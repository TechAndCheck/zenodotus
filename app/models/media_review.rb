# typed: strict

class MediaReview < ApplicationRecord
  belongs_to :archive_item, optional: true, class_name: "ArchiveItem"
end
