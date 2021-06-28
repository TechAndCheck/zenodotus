# typed: ignore

class TwitterImage < ActiveRecord::Base
  include ImageUploader::Attachment(:image)
end
