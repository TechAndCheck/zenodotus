# typed: ignore
require "test_helper"

class ArchiveControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "index redirects without authentication" do
    get root_url
    assert_redirected_to new_user_session_path
  end

  test "load index if authenticated" do
    sign_in users(:user1)
    get root_url
    assert_response :success
  end

  test "load correct model for url" do
    model_for_twitter_url = ArchiveItem.model_for_url("https://twitter.com/EFF/status/1427321758311387136")
    model_for_instagram_url = ArchiveItem.model_for_url("https://www.instagram.com/p/CSjrCgrrZq4/")
    model_for_facebook_url = ArchiveItem.model_for_url("https://www.facebook.com/barackobama/videos/632588137735860/")
    assert_equal model_for_twitter_url, Sources::Tweet
    assert_equal model_for_instagram_url, Sources::InstagramPost
    assert_equal model_for_facebook_url, Sources::FacebookPost
  end

  test "scrape results update errors if there's no scrape found" do
    post scrape_result_callback_url
    assert_response :missing

    post scrape_result_callback_url, as: :json, params: { scrape_id: "XXXX" }
    assert_response :missing
  end
end
