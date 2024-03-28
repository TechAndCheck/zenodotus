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
    ims = InstagramMediaSource.new("https://www.example.com")
    assert ims.invalid_url
  end

  test "an invalid instagram post url raises error" do
    ims = InstagramMediaSource.new("https://www.instagram.com/CBcqOkyDDH8/")
    assert ims.invalid_url
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
    instagram_post_hash = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)
    assert_not instagram_post_hash.empty?
  end

  test "extracting without force returns true" do
    instagram_post_response = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, false)
    assert instagram_post_response
  end

  test "a bad url raises an exception" do
    assert_raises InstagramMediaSource::InvalidInstagramPostUrlError do
      InstagramMediaSource.send(:extract_instagram_id_from_url, "https://instagram.com/")
    end
  end

  test "id can be pulled from variations of the url" do
    assert InstagramMediaSource.validate_instagram_post_url("https://www.instagram.com/9thstreetjournal/p/C4qqX1LvBbU/")
    assert InstagramMediaSource.validate_instagram_post_url("https://www.instagram.com/p/C4qqX1LvBbU/")
    assert InstagramMediaSource.validate_instagram_post_url("https://www.instagram.com/reel/CvzTrIagwK2/")
    assert InstagramMediaSource.validate_instagram_post_url("https://www.instagram.com/tv/CvzTrIagwK2/")

    assert_equal "C1nPLjNrxct", InstagramMediaSource.extract_instagram_id_from_url("https://www.instagram.com/p/C1nPLjNrxct/")
    assert_equal "CvzTrIagwK2", InstagramMediaSource.extract_instagram_id_from_url("https://www.instagram.com/reel/CvzTrIagwK2/")
    assert_equal "CvzTrIagwK2", InstagramMediaSource.extract_instagram_id_from_url("https://www.instagram.com/tv/CvzTrIagwK2/")
    assert_equal "C4qqX1LvBbU", InstagramMediaSource.extract_instagram_id_from_url("https://www.instagram.com/9thstreetjournal/p/C4qqX1LvBbU/")
    assert_equal "C4qqX1LvBbU", InstagramMediaSource.extract_instagram_id_from_url("https://www.instagram.com/9thstreetjournal/reel/C4qqX1LvBbU/")
    assert_equal "C4qqX1LvBbU", InstagramMediaSource.extract_instagram_id_from_url("https://www.instagram.com/9thstreetjournal/tv/C4qqX1LvBbU/")
  end
end
