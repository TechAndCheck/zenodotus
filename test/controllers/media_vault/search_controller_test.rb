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

  test "can search media for private posts" do
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CHdIkUVBz3C/", users(:media_vault_user))
    Sources::YoutubePost.create_from_url!("https://www.youtube.com/watch?v=Df7UtQTFUMQ", users(:media_vault_user))
    Sources::YoutubePost.create_from_url!("https://youtube.com/shorts/OgWNIBZfwDI")

    assert_difference("ImageSearch.count") do
      sign_in users(:media_vault_user)

      video_file = File.open("test/mocks/media/youtube_media_23b12624-2ef2-4dcb-97d2-966aa9fcba80.mp4", binmode: true)
      media_search = ImageSearch.create_with_media_item(video_file, users(:media_vault_user), true)

      get media_vault_search_path(msid: media_search.id, private: true)
      assert_response :success

      results = media_search.run

      assert_equal 2, results.count

      results.each do |result|
        assert result[:video].private
      end
    end
  end

  test "can search media for public posts" do
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CHdIkUVBz3C/", users(:media_vault_user))
    Sources::YoutubePost.create_from_url!("https://www.youtube.com/watch?v=Df7UtQTFUMQ", users(:media_vault_user))
    Sources::YoutubePost.create_from_url!("https://youtube.com/shorts/OgWNIBZfwDI")

    assert_difference("ImageSearch.count") do
      sign_in users(:media_vault_user)

      video_file = File.open("test/mocks/media/youtube_media_23b12624-2ef2-4dcb-97d2-966aa9fcba80.mp4", binmode: true)
      media_search = ImageSearch.create_with_media_item(video_file, users(:media_vault_user), false)

      get media_vault_search_path(msid: media_search.id, private: false)
      assert_response :success

      results = media_search.run

      assert_equal 1, results.count

      results.each do |result|
        assert_not result[:video].private
      end
    end
  end

  test "can search Google Fact Check Explorer for test" do
    sign_in users(:media_vault_user)
    image_file = File.open("test/mocks/media/insulin-injection-3.jpg", binmode: true)
    media_search = ImageSearch.create_with_media_item(image_file, users(:media_vault_user), false)

    get media_vault_search_path(msid: media_search.id, private: false)

    # TODO: Check if google results are being returned, probably by fixing up the view
    # and then checking the response for the google results
    # assert_select "div#google-fact-check-explorer-results"
    assert_response :success
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
end
