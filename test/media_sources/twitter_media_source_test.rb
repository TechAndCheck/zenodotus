# typed: ignore

require "test_helper"

class TwitterMediaSourceTest < ActiveSupport::TestCase
  include Minitest::Hooks

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  def after_all
    if File.exist?("tmp") && File.directory?("tmp")
      FileUtils.rm_r("tmp")
    end
  end

  def test_non_twitter_url_set_invalid_url
    tms = TwitterMediaSource.new("https://www.example.com")
    assert tms.invalid_url
  end

  def test_invalid_tweet_url_sets_invalid_url
    tms = TwitterMediaSource.new("https://twitter.com/20")
    assert tms.invalid_url
  end

  def test_initializing_returns_object
    assert_not_nil TwitterMediaSource.new("https://twitter.com/jack/status/20")
  end

  def test_extracting_creates_twitter_post_object
    twitter_post_hash = TwitterMediaSource.extract("https://twitter.com/jack/status/20", true)
    assert_not twitter_post_hash.empty?
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
