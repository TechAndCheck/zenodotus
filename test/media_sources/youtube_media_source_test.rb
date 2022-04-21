# require "minitest/autorun"
require "test_helper"

class YoutubeMediaSourceTest < ActiveSupport::TestCase
  def setup
  end

  def test_non_youtube_url_raise_error
    assert_raises(MediaSource::HostError) do
      YoutubeMediaSource.new("https://www.example.com")
    end
  end

  def test_initializing_returns_object
    assert_not_nil YoutubeMediaSource.new("https://www.youtube.com/watch?v=Df7UtQTFUMQ")
  end

  def test_extracting_creates_youtube_post_object
    youtube_post_hash = YoutubeMediaSource.extract("https://www.youtube.com/watch?v=Df7UtQTFUMQ", true)
    assert_not youtube_post_hash.empty?
  end
end
