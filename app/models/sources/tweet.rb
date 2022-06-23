# typed: strict

class Sources::Tweet < ApplicationRecord
  include ArchivableItem
  include PgSearch::Model

  multisearchable against: :text


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

  # Create an +ArchiveItem+ from a +url+ as a string
  #
  # @!scope class
  # @params url String a string of a url
  # @params user The user adding the ArchiveItem
  # returns ArchiveItem with type Tweet that has been saved to the database
  sig { params(url: String, user: T.nilable(User)).returns(ArchiveItem) }
  def self.create_from_url(url, user = nil)
    birdsong_tweet = TwitterMediaSource.extract(url)
    Sources::Tweet.create_from_birdsong_hash(birdsong_tweet, user).first
  end

  # Spawns an ActiveJob tasked with creating an +ArchiveItem+ from a +url+ as a string
  #
  # @!scope class
  # @params url String a string of a url
  # @params user User the current user creating an ArchiveItem
  # returns ScraperJob
  sig { params(url: String, user: T.nilable(User)).returns(ScraperJob) }
  def self.create_from_url!(url, user = nil)
    ScraperJob.perform_later(TwitterMediaSource, Sources::Tweet, url, user)
  end

  # An alias for create_from_birdsong_hash painted with a generic name so it can be called in a model agnostic fashion
  # @params birdsong_tweets [Array[Birdsong:Tweet]] an array of tweets grabbed from Birdsong
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(birdsong_tweets: T::Array[Birdsong::Tweet], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_hash(birdsong_tweets, user = nil)
    create_from_birdsong_hash(birdsong_tweets, user)
  end

  # Create a +ArchiveItem+ from a +Birdsong::Tweet+
  #
  # @!scope class
  # @params birdsong_tweets [Array[Birdsong:Tweet]] an array of tweets grabbed from Birdsong
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(birdsong_tweets: T::Array[Birdsong::Tweet], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_birdsong_hash(birdsong_tweets, user = nil)
    birdsong_tweets.map do |birdsong_tweet|
      twitter_user = Sources::TwitterUser.create_from_birdsong_hash([birdsong_tweet.author]).first.twitter_user

      image_attributes = birdsong_tweet.image_file_names.map do |image_file_name|
        { image: File.open(image_file_name, binmode: true) }
      end

      video_attributes = birdsong_tweet.video_file_names.map do |video_file_name|
        { video: File.open(video_file_name.first, binmode: true), video_type: birdsong_tweet.video_file_type }
      end

      tweet_hash = {
        text:                  birdsong_tweet.text,
        twitter_id:            birdsong_tweet.id.to_s,
        language:              birdsong_tweet.language,
        author:                twitter_user,
        posted_at:             birdsong_tweet.created_at,
        images_attributes:     image_attributes,
        videos_attributes:     video_attributes
      }
      ArchiveItem.create!(archivable_item: Sources::Tweet.create!(tweet_hash), submitter: user)
    end
  end

  # Get the `service_id` of the Tweet, in this case the id that Twitter provides
  #
  # @returns String of the ID.
  sig { returns(String) }
  def service_id
    twitter_id
  end

  # Normalized representation of this archivable item for use in the view template.
  #
  # @returns Hash of normalized attributes.
  sig { returns(Hash) }
  def normalized_attrs_for_views
    {
      publishing_platform_shortname:    "twitter",
      publishing_platform_display_name: "Twitter",
      author_canonical_path:            self.author.nil? ? "" : url_helpers.twitter_user_path(self.author),
      author_profile_image_url:         self.author.nil? ? "" : self.author.profile_image_url,
      author_display_name:              self.author.nil? ? "" : self.author.display_name,
      author_username:                  self.author.handle,
      author_community_count:           self.author.nil? ? "" : self.author.followers_count,
      author_community_noun:            "follower",
      archive_item_self:                self,
      archive_item_caption:             self.text,
      published_at:                     self.posted_at,
    }
  end
end
