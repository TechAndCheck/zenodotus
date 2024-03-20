# typed: ignore

require "test_helper"

class MediaVault::SearchControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
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

  setup do
    host! Figaro.env.MEDIA_VAULT_HOST
  end

  test "must be logged in to view search" do
    get media_vault_search_url
    assert_response :redirect
  end

  test "may view search if logged in" do
    sign_in users(:media_vault_user)

    get media_vault_search_url
    assert_response :success
  end

  test "may run search if logged in" do
    sign_in users(:media_vault_user)

    get media_vault_search_url(q: "Biden")
    assert_response :success
  end

  test "creates text search history" do
    sign_in users(:media_vault_user)

    get media_vault_search_url(q: "Biden")

    assert_response :success
    assert_equal 1, TextSearch.count
  end

  test "can run private and public text search" do
    # Set up a private archived post
    @private_scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CHdIkUVBz3C",
      scrape_type: :instagram,
      user: users(:media_vault_user),
    })

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    @private_scrape.fulfill(zorki_image_post)

    sign_in users(:media_vault_user)

    get media_vault_search_url(q: "pardoned", private: true)

    assert_response :success
    assert_equal 1, TextSearch.first.run.count

    get media_vault_search_url(q: "pardoned", private: false)

    assert_response :success
    assert_equal 0, TextSearch.all[1].run.count
  end

  test "can search by url of media" do
    assert_difference("ImageSearch.count") do
      sign_in users(:media_vault_user)

      get media_vault_search_url(q: "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4")
      assert_response :redirect
    end
  end

  test "A url with nothing in a url search fails properly" do
    assert_no_difference("ImageSearch.count") do
      sign_in users(:media_vault_user)

      get media_vault_search_url(q: "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp")
      assert_redirected_to media_vault_root_url
      assert_equal "The URL you entered could not be found. Please check that it's correct or try another.", flash[:error]

      assert_response :redirect
    end
  end

  test "A url with a file is too large in a url search fails properly" do
    assert_no_difference("ImageSearch.count") do
      sign_in users(:media_vault_user)

      get media_vault_search_url(q: "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_30mb.mp4")
      assert_redirected_to media_vault_root_url
      assert_equal "The file you wanted to search is too large. You will have to make a clip that is less than 20mb.", flash[:error]

      assert_response :redirect
    end
  end

  test "A url with a file that isn't an image or video in a url search fails properly" do
    assert_no_difference("ImageSearch.count") do
      sign_in users(:media_vault_user)

      get media_vault_search_url(q: "https://sample-videos.com/xls/Sample-Spreadsheet-1000-rows.xls")
      assert_redirected_to media_vault_root_url
      assert_equal "The URL you entered is not a valid media file. Please check that it's correct or try another.", flash[:error]

      assert_response :redirect
    end
  end

  test "A url that doesn't point to a file in a url search fails properly" do
    assert_no_difference("ImageSearch.count") do
      sign_in users(:media_vault_user)

      get media_vault_search_url(q: "https://sample-videos.com")
      assert_redirected_to media_vault_root_url
      assert_equal "The URL you entered is not a valid media file. Please check that it's correct or try another.", flash[:error]

      assert_response :redirect
    end
  end

  # TODO: check too large of a file, no file, and a file that's not a media

  # TODO: check that text search results are returned properly
  # TODO: check that media search history is created
  # TODO: check that media search results are returned properly
end
