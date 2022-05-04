# typed: ignore
require "test_helper"

class YoutubePostTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  @@youtube_archiver_post = nil
  @@youtube_archiver_post2 = nil

  def setup
    @@youtube_archiver_post = YoutubeMediaSource.extract("https://www.youtube.com/watch?v=Df7UtQTFUMQ", true)["scrape_result"] if @@youtube_archiver_post.nil?
    @@youtube_archiver_post2 = YoutubeMediaSource.extract("https://www.youtube.com/watch?v=kFFvomxcLWo", true) if @@youtube_archiver_post2.nil?
  end

  def teardown
    if File.exist?("tmp/youtube_archiver") && File.directory?("tmp/youtube_archiver")
      FileUtils.rm_r "tmp/youtube_archiver"
    end
  end

  test "can create youtube post" do
    archive_item = Sources::YoutubePost.create_from_youtube_archiver_hash(@@youtube_archiver_post).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item

    assert_equal @@youtube_archiver_post.first["post"]["title"], archive_item.youtube_post.title
    assert_equal @@youtube_archiver_post.first["post"]["id"], archive_item.youtube_post.youtube_id
    assert_equal @@youtube_archiver_post.first["post"]["id"], archive_item.service_id
    assert_equal @@youtube_archiver_post.first["post"]["live"], archive_item.youtube_post.live

    assert_not_nil archive_item.youtube_post.preview_image
    assert_not_nil archive_item.youtube_post.author
    assert_not_nil archive_item.youtube_post.videos
  end

  test "can archive youtube post from url" do
    youtube_post = Sources::YoutubePost.create_from_url!("https://www.youtube.com/watch?v=Df7UtQTFUMQ")
    youtube_post_2 = Sources::YoutubePost.create_from_url!("https://www.youtube.com/watch?v=kFFvomxcLWo")
    assert_not_nil youtube_post
    assert_not_nil youtube_post_2
  end

  test "can archive youtube short" do
    youtube_post = Sources::YoutubePost.create_from_url!("https://youtube.com/shorts/OgWNIBZfwDI?feature=share")
    assert_not_nil youtube_post
  end


  test "can archive youtube post from url using ActiveJob" do
    assert_enqueued_jobs 0
    assert_performed_jobs 0

    Sources::YoutubePost.create_from_url("https://www.youtube.com/watch?v=Df7UtQTFUMQ")
    Sources::YoutubePost.create_from_url("https://www.youtube.com/watch?v=kFFvomxcLWo")
    assert_enqueued_jobs 2

    perform_enqueued_jobs
    assert_performed_jobs 2
  end

  test "assert url can be checked" do
    assert Sources::YoutubePost.can_handle_url?("https://www.youtube.com/watch?v=Df7UtQTFUMQ")
    assert_not Sources::YoutubePost.can_handle_url?("https://twitter.com/AmtrakNECAlerts/status")
  end

  test "archiving a video creates a preview screenshot" do
    archive_item = Sources::YoutubePost.create_from_youtube_archiver_hash(@@youtube_archiver_post).first
    assert_not_nil archive_item.youtube_post.videos.first.video_derivatives[:preview]
  end
end
