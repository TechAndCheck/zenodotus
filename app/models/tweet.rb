# typed: false

class Tweet < ApplicationRecord
  include ArchivableItem

  # The `TwitterUser` that is the author of this tweet.
  belongs_to :author, class_name: "TwitterUser"

  # Returns a +boolean+ on whether this class can handle the URL passed in.
  # All items that are scraped should implement this class
  #
  # @!scope class
  # @params url String a url for an object to check
  # @return a Boolean on whether or not the class can handle the URL
  sig { params(url: String).returns(T::Boolean) }
  def self.can_handle_url?(url)
    TwitterMediaSource.send(:validate_tweet_url, url)
  rescue TwitterMediaSource::InvalidTweetUrlError => e
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
    Tweet.create_from_birdsong_hash(birdsong_tweet)
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
      twitter_user = TwitterUser.create_from_birdsong_hash([birdsong_tweet.author]).first.twitter_user

      ArchiveItem.create! archivable_item: Tweet.create({
        text: birdsong_tweet.text,
        twitter_id: "#{birdsong_tweet.id}",
        language: birdsong_tweet.language,
        author: twitter_user,
        posted_at: birdsong_tweet.created_at
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
