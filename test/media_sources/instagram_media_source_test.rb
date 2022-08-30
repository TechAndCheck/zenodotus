require "test_helper"

class InstagramMediaSourceTest < ActiveSupport::TestCase
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

  test "a non instagram_url raises an error" do
    assert_raises(MediaSource::HostError) do
      InstagramMediaSource.new("https://www.example.com")
    end
  end

  test "an invalid instagram post url raises error" do
    assert_raises(InstagramMediaSource::InvalidInstagramPostUrlError) do
      InstagramMediaSource.new("https://www.instagram.com/CBcqOkyDDH8/")
    end
  end

  test "extract_instagram_post_id_from_url_works" do
    assert_equal("CBcqOkyDDH", InstagramMediaSource.send(
        :extract_instagram_id_from_url,
        "https://www.instagram.com/p/CBcqOkyDDH"
      ))
  end

  test "initializing returns an object" do
    assert_not_nil InstagramMediaSource.new("https://www.instagram.com/p/CBcqOkyDDH8/")
  end

  test "extracting creates an instagram post object" do
    instagram_post_hash = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", true)
    assert_not instagram_post_hash.empty?
  end

  test "extracting without force returns true" do
    instagram_post_response = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", false)
    assert instagram_post_response
  end

  test "a bad url raises an exception" do
    assert_raises InstagramMediaSource::InvalidInstagramPostUrlError do
      InstagramMediaSource.send(:extract_instagram_id_from_url, "https://instagram.com/")
    end
  end
end
