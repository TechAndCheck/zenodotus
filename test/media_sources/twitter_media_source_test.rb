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

  def test_initializing_returns_nil
    assert_nil TwitterMediaSource.extract("https://twitter.com/jack/status/20")
  end

  def test_extracting_creates_screenshot
    screenshot_path = TwitterMediaSource.extract("https://twitter.com/jack/status/20", true)
    assert File.exist?(screenshot_path)
  end
end
