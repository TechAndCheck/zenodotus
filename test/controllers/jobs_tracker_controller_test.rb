require "test_helper"

class JobsTrackerControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "can view jobs" do
    sign_in users(:user1)
    get jobs_status_url
    assert_response :success
  end
end
