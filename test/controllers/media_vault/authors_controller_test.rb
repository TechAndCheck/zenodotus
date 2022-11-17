# typed: ignore

require "test_helper"

class MediaVault::AuthorsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! Figaro.env.MEDIA_VAULT_HOST
  end

  test "cannot view author page if logged out" do
    get media_vault_author_path("abc123", platform: :twitter)

    assert_redirected_to new_user_session_path
  end

  test "can view Facebook author page if logged in" do
    sign_in users(:media_vault_user)

    author = sources_facebook_users(:facebook_user)
    get media_vault_author_path(author, platform: :facebook)

    assert_response :success
  end

  test "can view Instagram author page if logged in" do
    sign_in users(:media_vault_user)

    author = sources_instagram_users(:instagram_user)
    get media_vault_author_path(author, platform: :instagram)

    assert_response :success
  end

  test "can view Twitter author page if logged in" do
    sign_in users(:media_vault_user)

    author = sources_twitter_users(:twitter_user)
    get media_vault_author_path(author, platform: :twitter)

    assert_response :success
  end

  test "can view YouTube channel page if logged in" do
    sign_in users(:media_vault_user)

    author = sources_youtube_channels(:youtube_channel)
    get media_vault_author_path(author, platform: :youtube)

    assert_response :success
  end

  test "can download Facebook author JSON" do
    sign_in users(:media_vault_user)

    author = sources_facebook_users(:facebook_user)
    get media_vault_author_path(author, platform: :facebook, format: :json)

    assert_response :success

    begin
      assert JSON.parse(@response.body)
    rescue JSON::ParserError
      flunk "Valid JSON was not returned."
    end
  end

  test "can download Instagram author JSON" do
    sign_in users(:media_vault_user)

    author = sources_instagram_users(:instagram_user)
    get media_vault_author_path(author, platform: :instagram, format: :json)

    assert_response :success

    begin
      assert JSON.parse(@response.body)
    rescue JSON::ParserError
      flunk "Valid JSON was not returned."
    end
  end

  test "can download Twitter author JSON" do
    sign_in users(:media_vault_user)

    author = sources_twitter_users(:twitter_user)
    get media_vault_author_path(author, platform: :twitter, format: :json)

    assert_response :success

    begin
      assert JSON.parse(@response.body)
    rescue JSON::ParserError
      flunk "Valid JSON was not returned."
    end
  end

  test "can download YouTube channel JSON" do
    sign_in users(:media_vault_user)

    author = sources_youtube_channels(:youtube_channel)
    get media_vault_author_path(author, platform: :youtube, format: :json)

    assert_response :success

    begin
      assert JSON.parse(@response.body)
    rescue JSON::ParserError
      flunk "Valid JSON was not returned."
    end
  end
end
