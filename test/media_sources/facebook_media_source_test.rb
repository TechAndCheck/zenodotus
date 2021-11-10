# require "minitest/autorun"
require "test_helper"

class FacebookMediaSourceTest < ActiveSupport::TestCase
  def setup
  end

  def test_non_facebook_url_raise_error
    assert_raises(MediaSource::HostError) do
      FacebookMediaSource.new("https://www.example.com")
    end
  end

  def test_invalid_facebook_post_url_raises_error
    assert_raises(FacebookMediaSource::InvalidFacebookPostUrlError) do
      FacebookMediaSource.new("https://www.facebook.com/381726605193429/photos/a.764764956889590/3625268454172545/")
    end
  end

  def test_initializing_returns_object
    assert_not_nil FacebookMediaSource.new("https://www.facebook.com/381726605193429/photos/a.764764956889590/3625268454172545/")
  end

  def test_extracting_creates_facebook_post_object
    facebook_post_hash = InstagramMediaSource.extract("https://www.facebook.com/381726605193429/photos/a.764764956889590/3625268454172545/", true)
    assert_not facebook_post_hash.empty?
  end
end
