# typed: ignore

class MediaModels::Videos::TwitterVideo < ApplicationRecord
  include VideoUploader::Attachment(:video)

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :tweet, optional: true, class_name: "Sources::Tweet"
end
