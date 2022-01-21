# typed: strict

class MediaReview < ApplicationRecord
  belongs_to :archive_item, optional: false, class_name: "ArchiveItem"
  # belongs_to :tweet, optional: true
  # belongs_to :instagram_post, optional: true
end
