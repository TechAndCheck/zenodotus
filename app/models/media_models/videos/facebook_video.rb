# typed: ignore

class MediaModels::Videos::FacebookVideo < ApplicationRecord
  include VideoUploader::Attachment(:video)

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :facebook_post, optional: true
end
