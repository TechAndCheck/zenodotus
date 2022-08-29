# require "minitest/autorun"
require "test_helper"

class FacebookMediaSourceTest < ActiveSupport::TestCase
  def setup
    @@forki_image_post = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/460964425465155", true)["scrape_result"]
  end

  def test_non_facebook_url_raise_error
    assert_raises(MediaSource::HostError) do
      FacebookMediaSource.new("https://www.example.com")
    end
  end

  def test_initializing_returns_object
    assert_not_nil FacebookMediaSource.new("https://www.facebook.com/381726605193429/photos/a.764764956889590/3625268454172545/")
  end

  def test_extracting_creates_facebook_post_object
    facebook_post_hash = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/460964425465155", true)
    assert_not facebook_post_hash.empty?
  end

  def test_extracting_returns_true_without_force
    result = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/460964425465155")
    assert result
  end
end
