# typed: ignore

require "test_helper"

class InstagramUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "cannot view Instagram user if logged out" do
    instagram_user = sources_instagram_users(:instagram_user)

    get instagram_user_path(id: instagram_user.id)

    assert_response :redirect
  end

  test "can view Instagram user if logged in" do
    instagram_user = sources_instagram_users(:instagram_user)

    sign_in users(:user)

    get instagram_user_path(id: instagram_user.id)

    assert_response :success
  end
end
