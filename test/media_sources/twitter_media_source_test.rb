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
    assert_raises(Birdsong::NoTweetFoundError) do
      TwitterMediaSource.extract("https://twitter.com/jack/status/1")
    end
  end

  def test_extracting_creates_tweet_object
    tweet_hash = TwitterMediaSource.extract("https://twitter.com/jack/status/20")
    tweet = Sources::Tweet.create_from_birdsong_hash(tweet_hash)
    assert_not tweet.empty?
  end

  def test_bad_url_raises_exception
    assert_raises TwitterMediaSource::InvalidTweetUrlError do
      TwitterMediaSource.send(:extract_tweet_id_from_url, "https://twitter.com/")
    end
  end
end
