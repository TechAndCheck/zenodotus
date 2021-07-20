# typed: false

class MediaModels::Images::TwitterImage < ActiveRecord::Base
  include ImageUploader::Attachment(:image)
  include Dhashable

  # Optional is marked true here because the image is technically saved before
  # it's added to the model itself.
  belongs_to :tweet, optional: true, class_name: "Sources::Tweet"

  def parent_post
    self.tweet
  end
end
