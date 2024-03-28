require "test_helper"

class TikTokMediaSourceTest < ActiveSupport::TestCase
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

  test "a non tiktok_url raises an error" do
    ims = TikTokMediaSource.new("https://www.example.com")
    assert ims.invalid_url
  end

  test "an invalid tik_tok post url raises error" do
    ims = TikTokMediaSource.new("https://www.tiktok.com/@guess//7091753416032128299/")
    assert ims.invalid_url
  end

  # test "extract_tik_tok_post_id_from_url_works" do
  #   assert_equal("7091753416032128299", TikTokMediaSource.send(
  #       :extract_tik_tok_id_from_url,
  #       "https://www.tiktok.com/@guess/video/7091753416032128299"
  #     ))
  # end

  test "initializing returns an object" do
    assert_not_nil TikTokMediaSource.new("https://www.tiktok.com/@guess/video/7091753416032128299/")
  end

  test "extracting creates an tik_tok post object" do
    tik_tok_post_hash = TikTokMediaSource.extract("https://www.tiktok.com/@guess/video/7091753416032128299/", MediaSource::ScrapeType::TikTok, true)
    assert_not tik_tok_post_hash.empty?
  end

  test "extracting without force returns true" do
    tik_tok_post_response = TikTokMediaSource.extract("https://www.tiktok.com/@guess/video/7091753416032128299/", MediaSource::ScrapeType::TikTok, false)
    assert tik_tok_post_response
  end

  test "a bad url raises an exception" do
    assert_raises TikTokMediaSource::InvalidTikTokPostUrlError do
      TikTokMediaSource.send(:extract_tik_tok_id_from_url, "https://tik_tok.com/")
    end
  end
end
