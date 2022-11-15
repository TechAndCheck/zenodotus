# typed: ignore

require "test_helper"

class MediaVault::SearchControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! Figaro.env.MEDIA_VAULT_HOST
  end

  test "must be logged in to view search" do
    get media_vault_search_url
    assert_response :redirect
  end

  test "may view search if logged in" do
    sign_in users(:media_vault_user)

    get media_vault_search_url
    assert_response :success
  end

  test "may run search if logged in" do
    sign_in users(:media_vault_user)

    get media_vault_search_url(q: "Biden")
    assert_response :success
  end

  test "creates text search history" do
    sign_in users(:media_vault_user)

    get media_vault_search_url(q: "Biden")

    assert_response :success
    assert_equal 1, TextSearch.count
  end

  # TODO: check that text search results are returned properly
  # TODO: check that media search history is created
  # TODO: check that media search results are returned properly
end
