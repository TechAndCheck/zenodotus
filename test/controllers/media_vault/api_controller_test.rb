require "test_helper"

class MediaVault::ArchiveControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include Minitest::Hooks

  test "test user jwt login works" do
    user = users(:user)
    sign_in user
    headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
    # This will add a valid token for `user` in the `Authorization` header
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

    get media_vault_api_submit_url, headers: auth_headers
    assert_response :success
  end
end
