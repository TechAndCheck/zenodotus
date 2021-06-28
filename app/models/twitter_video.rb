# typed: ignore

class TwitterVideo < ApplicationRecord
  include VideoUploader::Attachment(:video)
end
