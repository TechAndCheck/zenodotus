# typed: ignore

require "test_helper"

class TwitterUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "cannot view Twitter user if logged out" do
    twitter_user = sources_twitter_users(:twitter_user)

    get twitter_user_path(id: twitter_user.id)

    assert_response :redirect
  end

  test "can view Twitter user if logged in" do
    twitter_user = sources_twitter_users(:twitter_user)

    sign_in users(:user)

    get twitter_user_path(id: twitter_user.id)

    assert_response :success
  end
end
