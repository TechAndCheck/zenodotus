# typed: ignore

require "test_helper"

class MediaVault::TwitterUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "vault.factcheckinsights.local"
  end

  test "cannot view Twitter user if logged out" do
    twitter_user = sources_twitter_users(:twitter_user)

    get media_vault_twitter_user_path(twitter_user)

    assert_response :redirect
  end

  test "can view Twitter user if logged in" do
    twitter_user = sources_twitter_users(:twitter_user)

    sign_in users(:user)

    get media_vault_twitter_user_path(twitter_user)

    assert_response :success
  end

  test "can download user archive in JSON format" do
    twitter_user = sources_twitter_users(:twitter_user)

    sign_in users(:user)

    get media_vault_twitter_user_path(twitter_user, format: "json")

    assert_response :success

    begin
      assert JSON.parse(@response.body)
    rescue JSON::ParserError
      flunk "Valid JSON was not returned."
    end
  end
end
