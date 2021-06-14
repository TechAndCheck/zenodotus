# require "minitest/autorun"
require "test_helper"

class InstagramMediaSourceTest < ActiveSupport::TestCase
  def setup
  end

  def test_non_instagram_url_raise_error
    assert_raises(MediaSource::HostError) do
      InstagramMediaSource.new("https://www.example.com")
    end
  end

  def test_invalid_instagram_post_url_raises_error
    assert_raises(InstagramMediaSource::InvalidInstagramPostUrlError) do
      InstagramMediaSource.new("https://www.instagram.com/CBcqOkyDDH8/?utm_source=ig_embed")
    end
  end

  def test_extract_instagram_post_id_from_url_works
    assert_equal("CBcqOkyDDH", InstagramMediaSource.send(
        :extract_instagram_id_from_url,
        "https://www.instagram.com/p/CBcqOkyDDH"
      ))
  end

  def test_initializing_returns_object
    assert_not_nil InstagramMediaSource.new("https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed")
  end

  def test_extracting_creates_instagram_post_object
    instagram_post_hash = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed", true)
    assert_not instagram_post_hash.empty?
  end
end
