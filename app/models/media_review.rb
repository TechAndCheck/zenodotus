# typed: false

class MediaReview < ApplicationRecord

  belongs_to :archive_item, optional: false, class_name: "ArchiveItem"

end

