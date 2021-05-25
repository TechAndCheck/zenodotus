# typed: strict

class Tweet < ApplicationRecord
  include Mediable

  # Create a +Tweet+ from a +Birdsong::Tweet+
  #
  # @!scope class
  # @params birdsong_tweets [Array[Birdsong:Tweet]] an array of tweets grabbed from Birdsong
  # @returns [Array[MediaModels::Tweet]] and array of +MediaModels::Tweet+ that have been
  #   saved to the graph database
  sig { params(birdsong_tweets: T::Array[Birdsong::Tweet]).returns(T::Array[Tweet]) }
  def self.create_from_birdsong_hash(birdsong_tweets)
    birdsong_tweets.map do |birdsong_tweet|
      Tweet.create({
        text: birdsong_tweet.text,
        twitter_id: birdsong_tweet.id,
        language: birdsong_tweet.language
      })
    end
  end
end
