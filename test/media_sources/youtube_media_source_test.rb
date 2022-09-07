# require "minitest/autorun"
require "test_helper"

class YoutubeMediaSourceTest < ActiveSupport::TestCase
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

  test "a non YouTube url raises an error" do
    assert_raises(MediaSource::HostError) do
      YoutubeMediaSource.new("https://www.example.com")
    end
  end

  test "initializing returns an object" do
    assert_not_nil YoutubeMediaSource.new("https://www.youtube.com/watch?v=Df7UtQTFUMQ")
  end

  test "extracting creates a YoutubePost object" do
    youtube_post_hash = YoutubeMediaSource.extract("https://www.youtube.com/watch?v=Df7UtQTFUMQ", true)
    assert_not youtube_post_hash.empty?
  end
end
