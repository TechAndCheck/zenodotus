# typed: ignore

require "test_helper"

class MediaVault::FacebookUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "vault.factcheckinsights.local"
  end

  test "cannot view Facebook user if logged out" do
    facebook_user = sources_facebook_users(:facebook_user)

    get media_vault_facebook_user_path(facebook_user)

    assert_response :redirect
  end

  test "can view Facebook user if logged in" do
    facebook_user = sources_facebook_users(:facebook_user)

    sign_in users(:user)

    get media_vault_facebook_user_path(facebook_user)

    assert_response :success
  end

  test "can download user archive in JSON format" do
    facebook_user = sources_facebook_users(:facebook_user)

    sign_in users(:user)

    get media_vault_facebook_user_path(facebook_user, format: "json")

    assert_response :success

    begin
      assert JSON.parse(@response.body)
    rescue JSON::ParserError
      flunk "Valid JSON was not returned."
    end
  end
end
