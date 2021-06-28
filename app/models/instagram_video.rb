# typed: ignore

class InstagramVideo < ApplicationRecord
  include VideoUploader::Attachment(:video)
end
