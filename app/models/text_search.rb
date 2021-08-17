# typed: ignore

class TextSearch < ApplicationRecord

  # Runs the search against all images in the database given the +image+ attached
  #
  #
  # @return An ordered array of the search results with the format
  # { image: ArchiveItem, score: Float }
  # sig { returns(T::Array[T::Hash[ArchiveItem, Float]]) }
  def run
    # def search
    @search_term = query
    # @user_search_hits = UnifiedUser.search_users(@search_term)
    # @post_search_hits = UnifiedPost.search_posts(@search_term)
    {
      user_search_hits: UnifiedUser.search_users(@search_term),
      post_search_hits: UnifiedPost.search_posts(@search_term)
    }
  end
    # end

  #   images = ArchiveItem.all.filter_map do |archive_item|
  #     # Right now we're only doing images, and only one at the moment. We'll expand that later though
  #     next if archive_item.images.empty?
  #     image = archive_item.images.first
  #
  #     dhash = DHashVips::IDHash.distance3 self.dhash.to_i, image.dhash.to_i
  #     { image: image, score: dhash }
  #   end
  #
  #   images.sort do |image1, image2|
  #     image1[:score] <=> image2[:score]
  #   end
  # end
end
