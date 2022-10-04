require "test_helper"

class MediaVaultControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "vault.factcheckinsights.local"
  end

  test "should not allow Insights-only users to view archive" do
    sign_in users(:insights_user)

    get media_vault_archive_root_url

    assert_response :redirect
    assert_equal "You are not authorized to access that resource.", flash[:error]
  end
end
