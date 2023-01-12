require "test_helper"

class MediaVault::MediaControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  include Devise::Test::IntegrationHelpers
  include Minitest::Hooks

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end


  setup do
    host! Figaro.env.MEDIA_VAULT_HOST
  end

  test "cannot view media if not logged in" do
    get media_vault_medium_path(id: "abc123")
    assert_redirected_to new_user_session_path
  end

  test "can export media item metadata" do 
    user = users(:user)
    sign_in user

    archive_item = Sources::Tweet.create_from_url!("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
   
    get media_vault_export_media_metadata_path(archive_item.id)
    assert_response :success
    assert_equal "application/json", response.content_type

    json = JSON.parse response.body
    assert json.has_key?("archivable_item")
  end

  # TODO: Make this test work by ensuring we have ArchiveItem fixtures
  # test "can view individual piece of media" do
  #   sign_in users(:media_vault_user)

  #   archive_item = ArchiveItem.first

  #   get media_vault_medium_path(archive_item)
  #   assert_response :success
  # end
end
