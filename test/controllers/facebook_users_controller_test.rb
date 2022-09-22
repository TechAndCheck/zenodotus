# typed: ignore

require "test_helper"

class FacebookUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "cannot view Facebook user if logged out" do
    facebook_user = sources_facebook_users(:facebook_user)

    get facebook_user_path(id: facebook_user.id)

    assert_response :redirect
  end

  test "can view Facebook user if logged in" do
    facebook_user = sources_facebook_users(:facebook_user)

    sign_in users(:user)

    get facebook_user_path(id: facebook_user.id)

    assert_response :success
  end
end
