# typed: ignore

require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "must have unique hosts for each app" do
    all_hosts = SiteDefinitions::ALL.pluck(:host)

    assert_equal all_hosts.uniq, all_hosts
  end

  # If this test fails, it is likely because you do not have a unique host for Insights,
  # and so the Vault definition is overwriting.
  test "can recognize the Insights host" do
    host! Figaro.env.FACT_CHECK_INSIGHTS_HOST
    get root_url

    assert_predicate @controller, :site_is_fact_check_insights?
  end

  test "can recognize the Vault host" do
    host! Figaro.env.MEDIA_VAULT_HOST
    get root_url

    assert_predicate @controller, :site_is_media_vault?
  end
end
