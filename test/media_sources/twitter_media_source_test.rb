# typed: ignore

require "test_helper"

class TwitterMediaSourceTest < ActiveSupport::TestCase
  include Minitest::Hooks

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

  def test_initializing_returns_object
    assert_not_nil TwitterMediaSource.new("https://twitter.com/jack/status/20")
  end

  def test_extracting_creates_twitter_post_object
    twitter_post_hash = TwitterMediaSource.extract("https://twitter.com/jack/status/20", true)
    assert_not twitter_post_hash.empty?
  end

  def test_initializing_returns_blank
    assert_raises(Birdsong::NoTweetFoundError) do
      TwitterMediaSource.extract("https://twitter.com/jack/status/1")
    end
  end

  def test_unfound_tweet_raises
    assert_raises(TwitterMediaSource::ExternalServerError) do
      TwitterMediaSource.extract("https://twitter.com/jack/status/1", true)
    end
  end

  def test_bad_url_raises_exception
    assert_raises TwitterMediaSource::InvalidTweetUrlError do
      TwitterMediaSource.send(:extract_tweet_id_from_url, "https://twitter.com/")
    end
  end
end
