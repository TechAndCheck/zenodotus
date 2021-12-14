# typed: ignore

class ImageSearch < ApplicationRecord
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
  include Dhashable

  # Runs the search against all images in the database given the +image+ attached
  #
  # Right now this is very very slow due to it doing all the dhashing in Ruby. We can probably move
  # this to the database in a function eventually.
  #
  # @return An ordered array of the search results with the format
  # { image: ArchiveItem, score: Float }
  sig { returns(T::Array[T::Hash[ArchiveItem, Float]]) }
  def run
    images = ArchiveItem.all.filter_map do |archive_item|
      # Right now we're only doing images, and only one at the moment. We'll expand that later though
      next if archive_item.images.empty?
      image = archive_item.images.first

      dhash_score = Eikon::Comparator.compare(self.dhash, image.dhash)
      # dhash = DHashVips::IDHash.distance3 self.dhash.to_i, image.dhash.to_i
      { image: image, score: dhash_score }
    end

    images.sort do |image1, image2|
      image1[:score] <=> image2[:score]
    end
  end
end
