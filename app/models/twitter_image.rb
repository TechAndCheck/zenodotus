# typed: false

class TwitterImage < ActiveRecord::Base
  include ImageUploader::Attachment(:image)
  include Dhashable
end
