# typed: ignore

class MediaModels::Images::InstagramImage < ApplicationRecord
  include ImageUploader::Attachment(:image)
  include Dhashable

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :instagram_post, optional: true, class_name: "Sources::InstagramPost"

  def parent_post
    self.instagram_post
  end
end
