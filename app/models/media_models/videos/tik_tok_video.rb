# typed: ignore

class MediaModels::Videos::TikTokVideo < ApplicationRecord
  include VideoUploader::Attachment(:video)

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :tik_tok_post, optional: true, class_name: "Sources::TikTokPost"
end
