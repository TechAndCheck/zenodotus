# typed: false

class Screenshot < ApplicationRecord
  include ImageUploader::Attachment(:image)

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :archive_item, optional: true, class_name: "ArchiveItem"
end
