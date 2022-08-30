# typed: ignore

require "test_helper"

class ArchiveControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include Minitest::Hooks

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  def after_all
    if File.exist?("tmp/scrapers") && File.directory?("tmp/scrapers")
      FileUtils.rm_r "tmp/scrapers"
    end
  end

  test "index redirects without authentication" do
    get root_url
    assert_redirected_to new_user_session_path
  end

  test "load index if authenticated" do
    sign_in users(:user1)
    get root_url
    assert_response :success
  end

  test "load correct model for url" do
    model_for_twitter_url = ArchiveItem.model_for_url("https://twitter.com/EFF/status/1427321758311387136")
    model_for_instagram_url = ArchiveItem.model_for_url("https://www.instagram.com/p/CSjrCgrrZq4/")
    model_for_facebook_url = ArchiveItem.model_for_url("https://www.facebook.com/barackobama/videos/632588137735860/")
    assert_equal model_for_twitter_url, Sources::Tweet
    assert_equal model_for_instagram_url, Sources::InstagramPost
    assert_equal model_for_facebook_url, Sources::FacebookPost
  end

  test "scrape results update errors if there's no scrape found" do
    post scrape_result_callback_url
    assert_response :missing

    post(scrape_result_callback_url, as: :json, params: { scrape_id: "XXXX", scrape_result: [{}] })
    assert_response :missing
  end

  test "scrape callback works" do
    # First we need to construct a callback response. Since we can't really test the callback flow we
    # construct a mock callback. Since doing that by hard coding is actually annoying as hell we first
    # make a forced scrape call to Hypatia, then create it from there

    instagram_mocks_file = File.open("test/mock_data/instagram_posts.json")
    hypatia_mock_response = JSON.parse(instagram_mocks_file.read)["https://www.instagram.com/p/CBcqOkyDDH8/"]
    instagram_mocks_file.close

    hypatia_mock_response["scrape_result"] = JSON.dump(hypatia_mock_response["scrape_result"])
    # file.close

    scrape = Scrape.create!({ url: "https://www.instagram.com/p/CBcqOkyDDH8/", scrape_type: :instagram })
    callback_response_json = { scrape_id: scrape.id, scrape_result: hypatia_mock_response["scrape_result"] }
    post scrape_result_callback_url, as: :json, params: callback_response_json
    assert_response :success

    scrape.reload
    assert_not_nil scrape.archive_item
  end
end
