# typed: ignore

require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "can recognize the Insights subdomain" do
    host! "www.factcheckinsights.local"
    get root_url

    assert @controller.site_is_fact_check_insights?
  end

  test "can recognize the Vault subdomain" do
    host! "vault.factcheckinsights.local"
    get root_url

    assert @controller.site_is_media_vault?
  end
end
