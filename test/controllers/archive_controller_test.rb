# typed: ignore
require "test_helper"

class ArchiveControllerTest < ActionDispatch::IntegrationTest
  test "should load index" do
    get root_url
    assert_response :success
  end
  test "load correct model for url" do
    model_for_twitter_url = ArchiveItem.model_for_url("https://twitter.com/EFF/status/1427321758311387136")
    model_for_instagram_url = ArchiveItem.model_for_url("https://www.instagram.com/p/CSjrCgrrZq4/")
    assert_equal model_for_twitter_url, Sources::Tweet
    assert_equal model_for_instagram_url, Sources::InstagramPost
  end
end
