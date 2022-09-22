require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "can load the login page while logged out" do
    get new_user_session_path
    assert_response :success
  end

  test "cannot access the login page while logged in" do
    user = users(:user)

    sign_in user

    get new_user_session_path
    assert_response :redirect
  end
end
