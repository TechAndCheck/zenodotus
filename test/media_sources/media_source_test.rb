require "test_helper"

class MediaSourceTest < ActiveSupport::TestCase
  include Minitest::Hooks

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  def after_all
    if File.exist?("tmp") && File.directory?("tmp")
      FileUtils.rm_r("tmp")
    end
  end

  test "Can extract media post URLs from Archive.org addresses" do
    # Check that we can archive URLs with different protocol schemes
    https_post_url = "https://twitter.com/AmtrakNECAlerts/status/1397922363551870990"
    http_post_url = "http://twitter.com/AmtrakNECAlerts/status/1397922363551870990"

    archive_to_direct_url_map = {
      "http://web.archive.org/web/20220930151009/https://twitter.com/AmtrakNECAlerts/status/1397922363551870990" => https_post_url,
      "http://web.archive.org/web/20220930151009/http://twitter.com/AmtrakNECAlerts/status/1397922363551870990" => http_post_url,
      "https://web.archive.org/web/20220930151009/http://twitter.com/AmtrakNECAlerts/status/1397922363551870990" => http_post_url,
      "https://web.archive.org/web/20220930151009/https://twitter.com/AmtrakNECAlerts/status/1397922363551870990" => https_post_url
    }

    archive_to_direct_url_map.each  do |archive_url, post_url|
      assert_equal post_url, MediaSource.extract_post_url_if_needed(archive_url)
    end
  end

  test "Can archive media using archive.org URLs" do
    assert_not_nil Sources::Tweet.create_from_url!("https://web.archive.org/web/20220930151009/https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
  end
end
