# typed: ignore

require "test_helper"

class MediaVault::TextSearchControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "vault.factcheckinsights.local"
  end

  test "must be logged in to view text search" do
    get media_vault_text_search_url
    assert_response :redirect
  end

  test "may view text search if logged in" do
    sign_in users(:user)

    get media_vault_text_search_url
    assert_response :success
  end

  test "must be logged in to perform text search" do
    get media_vault_text_search_submit_url query: "Biden"
    assert_response :redirect
  end

  test "may perform text search if logged in" do
    sign_in users(:user)

    get media_vault_text_search_submit_url query: "Biden"
    assert_response :success
  end

  test "can run text search" do
    # First we need to create a few posts.
    Sources::Tweet.create_from_url("https://twitter.com/POTUS/status/1430341234472669188")
    Sources::Tweet.create_from_url("https://twitter.com/ggreenwald/status/1430523746457112578")
    Sources::Tweet.create_from_url("https://twitter.com/bidenfoundation/status/1121446608040755200")
    Sources::Tweet.create_from_url("https://twitter.com/POTUS/status/1428115295756066824")
    sign_in users(:user)

    # And then search
    get media_vault_text_search_submit_url, params: { query: "Biden" }

    assert_response 200
    assert_equal TextSearch.all.length, 1
  end
end
