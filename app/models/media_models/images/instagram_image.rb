# typed: false

class MediaModels::Images::InstagramImage < ApplicationRecord
  include ImageUploader::Attachment(:image)
  include Dhashable

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :instagram_post, optional: true, class_name: "Sources::InstagramPost"

  # Returns the parent object of this item. All the MediaModels implement this.
  #
  # @return the parent post of this object
  sig { returns(Sources::InstagramPost) }
  def parent_post
    self.instagram_post
  end
end
