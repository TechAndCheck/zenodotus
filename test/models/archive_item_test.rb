# typed: strict

require "test_helper"

class ArchiveItemTest < ActionDispatch::IntegrationTest
  include Minitest::Hooks
  include Devise::Test::IntegrationHelpers

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  test "destroying a user resets the submitter_id of ArchiveItems it created" do
    sign_in users(:user)
    Sources::Tweet.create_from_url! "https://twitter.com/jack/status/20", users(:user)
    assert_not_nil ArchiveItem.first.submitter
    User.destroy(users(:user).id)
    assert_nil ArchiveItem.first.submitter
  end

  test "scraping a post creates a screenshot" do
    forki_post = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/460964425465155", true)["scrape_result"]
    archive_item = Sources::FacebookPost.create_from_forki_hash(forki_post).first
    assert_not_nil archive_item.screenshot
  end
end
