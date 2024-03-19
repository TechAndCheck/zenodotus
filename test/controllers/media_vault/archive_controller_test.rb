# typed: ignore

require "test_helper"

class MediaVault::ArchiveControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include Minitest::Hooks

  setup do
    host! Figaro.env.MEDIA_VAULT_HOST
  end

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
    get media_vault_dashboard_url
    assert_redirected_to new_user_session_path
  end

  test "load index if authenticated" do
    sign_in users(:user)
    get media_vault_dashboard_url
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

  test "only a media vault user or super user can submit a url" do
    sign_in users(:fact_check_insights_user)
    get media_vault_archive_add_path
    assert_response :redirect

    sign_in users(:media_vault_user)
    get media_vault_archive_add_path(format: :turbo_stream)
    assert_response :success

    sign_in users(:admin)
    get media_vault_archive_add_path(format: :turbo_stream)
    assert_response :success
  end

  test "can submit a url for scraping ad hoc" do
    sign_in users(:media_vault_user)
    get media_vault_archive_add_path(format: :turbo_stream)
    assert_response :success # Not sure why this is redirecting, should be `:success`

    assert_changes -> { Scrape.count } do
      post media_vault_archive_add_path, params: { url_to_archive: "https://www.instagram.com/p/CBcqOkyDDH8/" }

      assert_response :redirect
    end
  end

  test "scrape results update errors if there's no scrape found" do
    post media_vault_archive_scrape_result_callback_url
    assert_response :missing

    post(media_vault_archive_scrape_result_callback_url, as: :json, params: { scrape_id: "XXXX", scrape_result: [{}] })
    assert_response :missing
  end

  test "scrape callback works" do
    # In this test, we imitate the flow of Zenodotus processing a MediaReview JSON object sent over by FactStream
    # In the first step of this flow, Zenodotus creates an orphaned `MediaReview` item
    # It then sends a scrape request to Hypatia
    #
    # The part of the flow we test here follows:
    # Hypatia responds to Zenodotus' scrape request with a callback, whereupon Zenodotus uses the callback response to create a new `ArchiveItem`
    # Zenodotus then updates the orphaned `MediaReview` item with a link to the new `ArchiveItem`

    # We first create an orphaned `MediaReview` item
    test_post_url = "https://www.instagram.com/p/CBcqOkyDDH8/"
    # media_review_item = MediaReview.create!({
    #   original_media_link: "https://www.instagram.com/p/CBcqOkyDDH8/",
    #   url: "https://www.foobar.com/",
    #   date_published: "2022-02-22",
    #   author: { "name": "foobar" },
    #   media_authenticity_category: "a category",
    #   original_media_context_description: "context context",
    #   item_reviewed: { "param": "value" }
    # })

    # Next, we create a mock callback response body
    instagram_mocks_file = File.open("test/mocks/data/instagram_posts.json")
    hypatia_mock_response = JSON.parse(instagram_mocks_file.read)[test_post_url]
    hypatia_mock_response["scrape_result"] = JSON.dump(hypatia_mock_response["scrape_result"])
    instagram_mocks_file.close

    # We then embed the mock response body within a hash
    scrape = Scrape.create!({ url: "https://www.instagram.com/p/CBcqOkyDDH8/", scrape_type: :instagram })
    callback_response_json = { scrape_id: scrape.id, scrape_result: hypatia_mock_response["scrape_result"] }

    # This hash is POSTed to Zenodotus' `/scrape_result_callback` route
    # Zenodotus then (eventually) calls `Scrape.fulfill`, which creates an `ArchiveItem` from the Hypatia response data
    # and links the orphaned `MediaReview` to the `ArchiveItem`.
    assert_enqueued_jobs 1 do
      post media_vault_archive_scrape_result_callback_url, as: :json, params: callback_response_json
    end
    assert_response :success
  end

  test "vault only shows all items it should" do
    # This is public
    post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    Sources::InstagramPost.create_from_zorki_hash(post)

    sign_in users(:user)
    get media_vault_dashboard_url
    assert_response :success

    assert_select "div.archive-item", count: 1
  end

  test "personal vault only shows the user's own items" do
    post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    Sources::InstagramPost.create_from_zorki_hash(post)

    sign_in users(:user)
    get media_vault_personal_dashboard_url
    assert_response :success
    assert_select "div.archive-item", count: 0
  end

  test "personal vault doesn't show other user's items" do
    sign_in users(:user)
    post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    Sources::InstagramPost.create_from_zorki_hash(post, users(:user))

    get media_vault_personal_dashboard_url
    assert_response :success
    assert_select "div.archive-item", count: 1

    post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    Sources::InstagramPost.create_from_zorki_hash(post, users(:media_vault_user))

    post = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    Sources::InstagramPost.create_from_zorki_hash(post, users(:media_vault_user))

    assert_select "div.archive-item", count: 1

    # Sign in with a different user
    sign_in users(:media_vault_user)
    get media_vault_personal_dashboard_url
    assert_response :success
    assert_select "div.archive-item", count: 2
  end

  test "can switch to personal vault" do
    sign_in users(:user)
    get media_vault_dashboard_url
    assert_response :success
    assert_select "a[href=?]", media_vault_personal_dashboard_path
    get media_vault_personal_dashboard_url
    assert_response :success
  end
end
