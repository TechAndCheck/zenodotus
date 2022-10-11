# typed: ignore

require "test_helper"

class MediaVault::InstagramUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "vault.factcheckinsights.local"
  end

  test "cannot view Instagram user if logged out" do
    instagram_user = sources_instagram_users(:instagram_user)

    get media_vault_instagram_user_path(instagram_user)

    assert_response :redirect
  end

  test "can view Instagram user if logged in" do
    instagram_user = sources_instagram_users(:instagram_user)

    sign_in users(:user)

    get media_vault_instagram_user_path(instagram_user)

    assert_response :success
  end

  test "can download user archive in JSON format" do
    instagram_user = sources_instagram_users(:instagram_user)

    sign_in users(:user)

    get media_vault_instagram_user_path(instagram_user, format: "json")

    assert_response :success

    begin
      assert JSON.parse(@response.body)
    rescue JSON::ParserError
      flunk "Valid JSON was not returned."
    end
  end
end
