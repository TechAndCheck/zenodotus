# typed: ignore

class InstagramImage < ActiveRecord::Base
  include ImageUploader::Attachment(:image)
  include Dhashable
end
