# typed: false

class Sources::Tweet < ApplicationRecord
  include ArchivableItem
  has_many :images, foreign_key: :tweet_id, class_name: "MediaModels::Images::TwitterImage", dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  has_many :videos, foreign_key: :tweet_id, class_name: "MediaModels::Videos::TwitterVideo", dependent: :destroy
  accepts_nested_attributes_for :videos, allow_destroy: true

  # has_one :media_review, foreign_key: :archive_item_id, class_name: "MediaReview", dependent: :destroy

  # The `TwitterUser` that is the author of this tweet.
  belongs_to :author, class_name: "TwitterUser"

  after_commit on: [:create] do
    # We only want to create the derivatives once (since you know, it's a media archive we don't
    # want them to change)
    self.videos.each { |video| video.video_derivatives! }
  end

  # update materialized view when a new tweet is added
  after_commit on: [:create, :destroy] do
    UnifiedTableRefreshJob.perform_later
  end

  # Returns a +boolean+ on whether this class can handle the URL passed in.
  # All items that are scraped should implement this class
  #
  # @!scope class
  # @params url String a url for an object to check
  # @return a Boolean on whether or not the class can handle the URL
  sig { params(url: String).returns(T::Boolean) }
  def self.can_handle_url?(url)
    TwitterMediaSource.send(:validate_tweet_url, url)
  rescue TwitterMediaSource::InvalidTweetUrlError
    false
  end

  # Create a +ArchiveItem+ from a +url+ as a string
  #
  # @!scope class
  # @params url String a string of a url
  # returns ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(url: String).returns(ArchiveItem) }
  def self.create_from_url(url)
    birdsong_tweet = TwitterMediaSource.extract(url)
    Sources::Tweet.create_from_birdsong_hash(birdsong_tweet).first
  end

  # Create a +ArchiveItem+ from a +Birdsong::Tweet+
  #
  # @!scope class
  # @params birdsong_tweets [Array[Birdsong:Tweet]] an array of tweets grabbed from Birdsong
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(birdsong_tweets: T::Array[Birdsong::Tweet]).returns(T::Array[ArchiveItem]) }
  def self.create_from_birdsong_hash(birdsong_tweets)
    birdsong_tweets.map do |birdsong_tweet|
      twitter_user = Sources::TwitterUser.create_from_birdsong_hash([birdsong_tweet.author]).first.twitter_user

      image_attributes = birdsong_tweet.image_file_names.map do |image_file_name|
        { image: File.open(image_file_name, binmode: true) }
      end

      video_attributes = birdsong_tweet.video_file_names.map do |video_file_name|
        { video: File.open(video_file_name.first, binmode: true) }
      end

      ArchiveItem.create! archivable_item: Sources::Tweet.create({
        text:                  birdsong_tweet.text,
        twitter_id:            birdsong_tweet.id.to_s,
        language:              birdsong_tweet.language,
        author:                twitter_user,
        posted_at:             birdsong_tweet.created_at,
        images_attributes:     image_attributes,
        videos_attributes:     video_attributes
      })
    end
  end

  # Get the `service_id` of the Tweet, in this case the id that Twitter provides
  #
  # @returns String of the ID.
  sig { returns(String) }
  def service_id
    twitter_id
  end
end
