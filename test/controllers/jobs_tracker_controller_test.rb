require "test_helper"

class JobsTrackerControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "can view jobs" do
    sign_in users(:user1)
    InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed", false)
    get jobs_status_url
    assert_response :success
  end
end
