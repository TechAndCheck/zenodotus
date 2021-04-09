# require "minitest/autorun"
require "test_helper"

class WebsiteMediaSourceTest < ActiveSupport::TestCase
  def setup
  end

  def test_initializing_returns_nil
    assert_nil WebsiteMediaSource.extract("https://www.example.com")
  end

  def test_extracting_creates_screenshot
    screenshot_path = WebsiteMediaSource.extract("https://www.example.com", true)
    assert File.exist?(screenshot_path)
  end
end
