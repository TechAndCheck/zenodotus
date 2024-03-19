require "test_helper"

class Sources::TikTokPostTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

  def before_all
    @@morris_video_post = TikTokMediaSource.extract("https://www.tiktok.com/@guess/video/7091753416032128299/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
  end

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

  test "can create Instagram post" do
    archive_item = Sources::TikTokPost.create_from_morris_hash(@@morris_video_post).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item

    assert_equal @@morris_video_post.first["post"]["text"], archive_item.tik_tok_post.text
    assert_equal @@morris_video_post.first["id"], archive_item.tik_tok_post.tik_tok_id
    assert_equal @@morris_video_post.first["id"], archive_item.service_id
    assert_equal @@morris_video_post.first["post"]["date"], archive_item.tik_tok_post.posted_at.strftime("%F %T %:z")

    assert_not_nil archive_item.tik_tok_post.author
    assert_not_nil archive_item.tik_tok_post.videos
  end

  test "can create from TikTok url" do
    assert_not_nil Sources::TikTokPost.create_from_url!("https://www.tiktok.com/@guess/video/7091753416032128299/")
  end

  test "can create from TikTok url using ActiveJob" do
    assert_enqueued_jobs 0
    assert Sources::TikTokPost.create_from_url("https://www.tiktok.com/@guess/video/7091753416032128299/")
    assert_enqueued_jobs 1

    assert_nothing_raised do
      perform_enqueued_jobs
    end
  end

  test "can create two TikTok posts from same author" do
    morris_post2 = TikTokMediaSource.extract("https://www.tiktok.com/@guess/video/7091753416032128299/", MediaSource::ScrapeType::TikTok, true)["scrape_result"]
    archive_item = Sources::TikTokPost.create_from_morris_hash(@@morris_video_post).first.tik_tok_post
    archive_item2 = Sources::TikTokPost.create_from_morris_hash(morris_post2).first.tik_tok_post
    assert_equal archive_item.author, archive_item2.author
  end

  test "assert_url_can_be_checked" do
    assert Sources::TikTokPost.can_handle_url?("https://www.tiktok.com/@guess/video/7091753416032128299/")
    assert_not Sources::TikTokPost.can_handle_url?("https://www.instagram.com/z/CQDeYPhMJLG/")
  end

  test "can kick off archive from TikTok post" do
    result = TikTokMediaSource.extract("https://www.tiktok.com/@guess/video/7091753416032128299/", MediaSource::ScrapeType::TikTok, true)
    assert result
  end

  test "can archive video from TikTok post" do
    archive_item = Sources::TikTokPost.create_from_morris_hash(@@morris_video_post)
    assert_not_nil archive_item
    assert_kind_of Array, archive_item
    assert_not_nil archive_item.first
    assert_not_nil archive_item.first.tik_tok_post.videos
  end

  # Note that this checks `image_hashes` because that's how the videos are processed.
  test "dhash properly generated from video" do
    archive_item = Sources::TikTokPost.create_from_morris_hash(@@morris_video_post).first
    assert_not_nil archive_item.image_hashes.first.dhash
  end

  test "archiving a video creates a preview screenshot" do
    archive_item = Sources::TikTokPost.create_from_morris_hash(@@morris_video_post).first
    assert_not_nil archive_item.tik_tok_post.videos.first.video_derivatives[:preview]
  end
end
