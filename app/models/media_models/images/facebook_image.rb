# typed: false

class MediaModels::Images::FacebookImage < ApplicationRecord
  include ImageUploader::Attachment(:image)

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :facebook_post, optional: true, class_name: "Sources::FacebookPost"

  # Returns the parent object of this item. All the MediaModels implement this.
  #
  # @return the parent post of this object
  sig { returns(Sources::InstagramPost) }
  def parent_post
    self.facebook_post
  end
end
