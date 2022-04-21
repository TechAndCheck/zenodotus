# typed: false

class MediaModels::Images::TwitterImage < ApplicationRecord
  include ImageUploader::Attachment(:image)

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :tweet, optional: true, class_name: "Sources::Tweet"

  # Returns the parent object of this item. All the MediaModels implement this.
  #
  # @return the parent post of this object
  sig { returns(Sources::Tweet) }
  def parent_post
    self.tweet
  end
end
