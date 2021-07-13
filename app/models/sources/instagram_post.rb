# typed: false

class Sources::InstagramPost < ApplicationRecord
  include ArchivableItem

  has_many :images, foreign_key: :instagram_post_id, class_name: "MediaModels::Images::InstagramImage", dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  has_many :videos, foreign_key: :instagram_post_id, class_name: "MediaModels::Videos::InstagramVideo", dependent: :destroy
  accepts_nested_attributes_for :videos, allow_destroy: true

  # The `TwitterUser` that is the author of this tweet.
  belongs_to :author, class_name: "InstagramUser"


  after_commit on: [:create] do
    # We only want to create the derivatives once (since you know, it's a media archive we don't
    # want them to change)
    self.videos.each { |video| video.video_derivatives! }
  end

  after_commit on: [:create, :destroy] do
    # update materialized view when a new tweet is added
    UnifiedUser.refresh
    UnifiedPost.refresh
  end

  # Returns a +boolean+ on whether this class can handle the URL passed in.
  # All items that are scraped should implement this class
  #
  # @!scope class
  # @params url String a url for an object to check
  # @return a Boolean on whether or not the class can handle the URL
  sig { params(url: String).returns(T::Boolean) }
  def self.can_handle_url?(url)
    InstagramMediaSource.send(:validate_instagram_post_url, url)
  rescue InstagramMediaSource::InvalidInstagramPostUrlError
    false
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
    Sources::InstagramPost.create_from_zorki_hash(zorki_post).first
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
      user = Sources::InstagramUser.create_from_zorki_hash([zorki_post.user]).first.instagram_user

      unless zorki_post.image_file_names.nil?
        image_attributes = zorki_post.image_file_names.map do |image_file_name|
          { image: File.open(image_file_name, binmode: true) }
        end
      else
        image_attributes = []
      end

      unless zorki_post.video_file_name.nil?
        video_attributes = [{ video: File.open(zorki_post.video_file_name, binmode: true) }]
      else
        video_attributes = []
      end

      hash = {
        text:              zorki_post.text,
        instagram_id:      zorki_post.id,
        posted_at:         zorki_post.date,
        number_of_likes:   zorki_post.number_of_likes,
        author:            user,
        images_attributes: image_attributes,
        videos_attributes: video_attributes
      }

      ArchiveItem.create! archivable_item: Sources::InstagramPost.create!(hash)
    end
  end

  # Get the `service_id` of the Instagram Post, in this case the id that Instagram provides
  #
  # @returns String of the ID.
  sig { returns(String) }
  def service_id
    instagram_id
  end
end
