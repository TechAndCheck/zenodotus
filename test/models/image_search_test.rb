require "test_helper"

class ImageSearchTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  include Minitest::Hooks

  def setup
    image_file = File.open("test/mocks/media/instagram_media_12765281-136d-4bfa-b7ad-e89f107b5769.jpg", binmode: true)
    video_file = File.open("test/mocks/media/youtube_media_23b12624-2ef2-4dcb-97d2-966aa9fcba80.mp4", binmode: true)
    @image_search = ImageSearch.create!(image: image_file, user: users(:user))
    @video_search = ImageSearch.create!(video: video_file, user: users(:user))

    Zelkova.graph.reset
  end

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  def teardown
    Zelkova.graph.reset
  end

  test "can create image search" do
    assert_not_nil @image_search
    assert_not_nil @image_search.image
    assert_not_nil @image_search.dhashes
  end

  test "can create image search with video" do
    assert_not_nil @video_search
    assert_not_nil @video_search.video
    assert_not_nil @video_search.dhashes
  end

  test "can run image search" do
    # First we need to create a few posts. The Shrine fixture way doesn't seem to actually work.
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CBcqOkyDDH8/")
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CQDeYPhMJLG/")
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CBZkDi1nAty/")
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CZ3_P6FrtMO/")
    results = @image_search.run

    assert_not_nil results

    # Make sure everything is in order
    in_order = true
    results.each_with_index do |result, index|
      # End if we have nothing to compare to (we're at the end)
      break if index == results.length - 1
      # Do the comparison
      if result[:distance] > results[index + 1][:distance]
        in_order = false
        break
      end
    end
    assert in_order, "Images should be returned in order of similarity (lower is better)"

    assert results.first[:distance] <= 10 # Identical images have distance 0, but downloading images may introduce artifacts, so we add some tolerance
  end

  test "can run video search" do
    # First we need to create a few posts. The Shrine fixture way doesn't seem to actually work.
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CHdIkUVBz3C/")
    Sources::YoutubePost.create_from_url!("https://www.youtube.com/watch?v=Df7UtQTFUMQ")
    Sources::YoutubePost.create_from_url!("https://youtube.com/shorts/OgWNIBZfwDI")

    results = @video_search.run

    assert_not_nil results

    # Make sure everything is in order
    in_order = true
    results.each_with_index do |result, index|
      # End if we have nothing to compare to (we're at the end)
      break if index == results.length - 1
      # Do the comparison
      if result[:distance] > results[index + 1][:distance]
        in_order = false
        break
      end
    end
    assert in_order, "Images should be returned in order of similarity (lower is better)"
    assert results.first[:distance] <= 20 # Identical images have distance 0, but downloading images may introduce artifacts, so we add some tolerance
  end
end
