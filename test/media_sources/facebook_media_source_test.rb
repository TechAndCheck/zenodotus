# require "minitest/autorun"
require "test_helper"

class FacebookMediaSourceTest < ActiveSupport::TestCase
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

  test "initializing returns an object" do
    assert_not_nil FacebookMediaSource.new("https://www.facebook.com/381726605193429/photos/a.764764956889590/3625268454172545/")
  end

  test "extracting creates a facebook post object" do
    facebook_post_hash = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/460964425465155", true)
    assert_not facebook_post_hash.empty?
  end

  test "extracting without force returns true" do
    result = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/460964425465155")
    assert result
  end
end
