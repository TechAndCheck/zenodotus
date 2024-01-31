require "test_helper"

class FacebookPostTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include Minitest::Hooks

  def before_all
    @@forki_image_post = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/a.108824087345859/336596487901950", MediaSource::ScrapeType::Facebook, true)["scrape_result"]
    @@forki_image_post_2 = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/460964425465155", MediaSource::ScrapeType::Facebook, true)["scrape_result"]
    @@forki_video_post = FacebookMediaSource.extract("https://www.facebook.com/Meta/videos/264436895517475", MediaSource::ScrapeType::Facebook, true)["scrape_result"]
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

  test "can create Facebook post" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_image_post).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item

    assert_equal @@forki_image_post.first["post"]["id"], archive_item.facebook_post.facebook_id
    assert_equal @@forki_image_post.first["id"], archive_item.service_id
    assert_equal @@forki_image_post.first["post"]["url"], archive_item.facebook_post.url
    assert_equal Time.at(@@forki_image_post.first["post"]["created_at"]).utc.strftime("%FT%T%:z"), archive_item.facebook_post.posted_at.strftime("%FT%T%:z")

    assert_nil @@forki_image_post.first["post"]["text"]
    assert_nil archive_item.facebook_post.text

    assert_not_nil archive_item.facebook_post.author
    assert_not_nil archive_item.facebook_post.images

    assert_predicate archive_item.facebook_post.number_of_likes, :positive?
    assert_predicate archive_item.facebook_post.number_of_love_reactions, :positive?
  end

  test "can archive Facebook post from url" do
    assert_not_nil Sources::FacebookPost.create_from_url("https://www.facebook.com/Meta/photos/460964425465155")
  end

  test "can create Facebook post from url using activejob" do
    Sources::FacebookPost.create_from_url!("https://www.facebook.com/Meta/photos/460964425465155")
    perform_enqueued_jobs

    facebook_post = Sources::FacebookPost.where(url: "https://www.facebook.com/Meta/photos/460964425465155").first
    assert_not_nil facebook_post
  end

  test "can create two facebook posts from same author" do
    facebook_post = Sources::FacebookPost.create_from_forki_hash(@@forki_image_post).first.facebook_post
    facebook_post_2 = Sources::FacebookPost.create_from_forki_hash(@@forki_image_post_2).first.facebook_post
    assert_equal facebook_post.author.name, facebook_post_2.author.name
    assert_equal 2, facebook_post.author.facebook_posts.count
  end

  test "assert url can be checked" do
    assert Sources::FacebookPost.can_handle_url?("https://www.facebook.com/MarkZuckerberg/videos/123456789/")
    assert_not Sources::FacebookPost.can_handle_url?("https://www.fakebook.com/Markerberg")
  end

  test "assert archive image from facebook post" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_image_post).first
    assert_not_empty archive_item.image_hashes
  end

  test "can archive video from Facebook post" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_video_post).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item
    assert_not_nil archive_item.facebook_post.videos
  end

  test "dhash properly generated from image" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_image_post).first
    assert_not_nil archive_item.image_hashes.first.dhash
  end

  test "archiving a video creates a preview screenshot" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_video_post).first
    assert_not_nil archive_item.facebook_post.videos.first.video_derivatives[:preview]
  end
end
