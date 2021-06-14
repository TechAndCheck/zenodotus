# typed: false

class InstagramPost < ApplicationRecord
  include ArchivableItem
  has_many :instagram_images, dependent: :destroy
  accepts_nested_attributes_for :instagram_images, allow_destroy: true

  # The `TwitterUser` that is the author of this tweet.
  belongs_to :author, class_name: "InstagramUser"

  # Returns a +boolean+ on whether this class can handle the URL passed in.
  # All items that are scraped should implement this class
  #
  # @!scope class
  # @params url String a url for an object to check
  # @return a Boolean on whether or not the class can handle the URL
  sig { params(url: String).returns(T::Boolean) }
  def self.can_handle_url?(url)
    begin
      InstagramMediaSource.send(:validate_instagram_post_url, url)
    rescue InstagramMediaSource::InvalidInstagramPostUrlError => e
      false
    end
  end

  # Create a +ArchiveItem+ from a +url+ as a string
  #
  # @!scope class
  # @params url String a string of a url
  # returns ArchiveItem with type InstagramPost that have been
  #   saved to the graph database
  sig { params(url: String).returns(ArchiveItem) }
  def self.create_from_url(url)
    zorki_post = InstagramMediaSource.extract(url)
    InstagramPost.create_from_zorki_hash(zorki_post)
  end

  # Create a +ArchiveItem+ from a +Zorki::Post+
  #
  # @!scope class
  # @params birdsong_tweets [Array[Zorki::Post]] an array of tweets grabbed from Birdsong
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(zorki_posts: T::Array[Zorki::Post]).returns(T::Array[ArchiveItem]) }
  def self.create_from_zorki_hash(zorki_posts)
    zorki_posts.map do |zorki_post|
      user = InstagramUser.create_from_zorki_hash([zorki_post.user]).first.instagram_user

      image_attributes = zorki_post.images.map do |image|
        { image: File.open(image, binmode: true) }
      end
      hash = {
        text:                       zorki_post.text,
        instagram_id:               zorki_post.id,
        posted_at:                  zorki_post.date,
        number_of_likes:            zorki_post.number_of_likes,
        author:                     user,
        instagram_images_attributes: image_attributes
      }

      ArchiveItem.create! archivable_item: InstagramPost.create!(hash)
    end
  end

  # Get the `service_id` of the Tweet, in this case the id that Twitter provides
  #
  # @returns String of the ID.
  sig { returns(String) }
  def service_id
    instagram_id
  end
end
