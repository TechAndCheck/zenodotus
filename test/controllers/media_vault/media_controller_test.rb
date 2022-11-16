require "test_helper"

class MediaVault::MediaControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! Figaro.env.MEDIA_VAULT_HOST
  end

  test "cannot view media if not logged in" do
    get media_vault_medium_path(id: "abc123")
    assert_redirected_to new_user_session_path
  end

  # TODO: Make this test work by ensuring we have ArchiveItem fixtures
  # test "can view individual piece of media" do
  #   sign_in users(:media_vault_user)

  #   archive_item = ArchiveItem.first

  #   get media_vault_medium_path(archive_item)
  #   assert_response :success
  # end
end
