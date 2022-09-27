# typed: ignore

require "test_helper"

class YoutubeChannelsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "cannot view YouTube channel if logged out" do
    youtube_channel = sources_youtube_channels(:youtube_channel)

    get youtube_channel_path(youtube_channel)

    assert_response :redirect
  end

  test "can view YouTube channel if logged in" do
    youtube_channel = sources_youtube_channels(:youtube_channel)

    sign_in users(:user)

    get youtube_channel_path(youtube_channel)

    assert_response :success
  end

  test "can download channel archive in JSON format" do
    youtube_channel = sources_youtube_channels(:youtube_channel)

    sign_in users(:user)

    get youtube_channel_path(youtube_channel, format: "json")

    assert_response :success

    begin
      assert JSON.parse(@response.body)
    rescue JSON::ParserError
      flunk "Valid JSON was not returned."
    end
  end
end
