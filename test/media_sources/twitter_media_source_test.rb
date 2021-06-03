# typed: ignore
# require "minitest/autorun"
require "test_helper"

class TwitterMediaSourceTest < ActiveSupport::TestCase
  def setup
  end

  def test_non_twitter_url_raise_error
    assert_raises(MediaSource::HostError) do
      TwitterMediaSource.new("https://www.example.com")
    end
  end

  def test_invalid_tweet_url_raises_error
    assert_raises(TwitterMediaSource::InvalidTweetUrlError) do
      TwitterMediaSource.new("https://twitter.com/20")
    end
  end

  def test_initializing_returns_blank
    assert TwitterMediaSource.extract("https://twitter.com/jack/status/1").empty?
  end

  def test_extracting_creates_tweet_object
    tweet_hash = TwitterMediaSource.extract("https://twitter.com/jack/status/20", true)
    tweet = Tweet.create_from_birdsong_hash(tweet_hash)
    assert_not tweet.empty?
  end
end
