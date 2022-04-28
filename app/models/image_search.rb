# typed: strict

class ImageSearch < ApplicationRecord
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
  include Dhashable

  belongs_to :user, optional: false, class_name: "User"

  # Runs the search against all images in the database given the +image+ attached
  #
  # Right now this is very very slow due to it doing all the dhashing in Ruby. We can probably move
  # this to the database in a function eventually.
  #
  # @return An ordered array of the search results with the format
  # { image: ArchiveItem, score: Float }
  sig { returns(T::Array[T::Hash[ArchiveItem, Float]]) }
  def run
    image_hashes = Zelkova.graph.search(self.dhash)
    images = image_hashes.map do |image_hash|
      hash = ImageHash.find(image_hash[:node].metadata[:id])
      { image: hash.archive_item, score: image_hash[:distance] }
    end

    images
  end
end
