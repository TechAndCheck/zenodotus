# typed: strict

class Tweet < ApplicationRecord
  include Mediable

  belongs_to :author, class_name: "MediaItem"

  # Create a +MediaItem+ from a +Birdsong::Tweet+
  #
  # @!scope class
  # @params birdsong_tweets [Array[Birdsong:Tweet]] an array of tweets grabbed from Birdsong
  # @returns [Array[MediaItem]] and array of MediaItem with type Tweet that have been
  #   saved to the graph database
  sig { params(birdsong_tweets: T::Array[Birdsong::Tweet]).returns(T::Array[MediaItem]) }
  def self.create_from_birdsong_hash(birdsong_tweets)
    birdsong_tweets.map do |birdsong_tweet|
      MediaItem.create! mediable: Tweet.create({
        text: birdsong_tweet.text,
        twitter_id: "#{birdsong_tweet.id}",
        language: birdsong_tweet.language,
        author: TwitterUser.create_from_birdsong_hash([birdsong_tweet.author]).first
      })
    end
  end

  sig { returns(String) }
  def service_id
    twitter_id
  end
end
