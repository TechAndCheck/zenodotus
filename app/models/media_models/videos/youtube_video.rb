# typed: ignore

class MediaModels::Videos::YoutubeVideo < ApplicationRecord
  include VideoUploader::Attachment(:video)

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :youtube_post, optional: true, class_name: "Sources::YoutubeVideo"
end
