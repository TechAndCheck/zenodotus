require "test_helper"

class MediaVaultControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! Figaro.env.MEDIA_VAULT_HOST
  end

  test "should not allow Insights-only users to view dashboard" do
    sign_in users(:fact_check_insights_user)

    get media_vault_dashboard_url

    assert_response :redirect
    assert_equal "You are not authorized to access that resource.", flash[:error]
  end
end
