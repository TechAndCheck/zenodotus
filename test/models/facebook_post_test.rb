require "test_helper"

class FacebookPostTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  @@forki_post = nil
  @@forki_facebook_post_video = nil

  def setup
    @@forki_post = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/a.108824087345859/336596487901950", true)["scrape_result"] if @@forki_post.nil?
    @@forki_facebook_post_video = FacebookMediaSource.extract("https://www.facebook.com/Meta/videos/264436895517475", true)["scrape_result"] if @@forki_facebook_post_video.nil?
  end

  def teardown
    if File.exist?("tmp/forki") && File.directory?("tmp/forki")
      FileUtils.rm_r "tmp/forki"
    end
  end

  test "can create Facebook post" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_post).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item

    assert_equal @@forki_post.first["post"]["text"], archive_item.facebook_post.text
    assert_equal @@forki_post.first["post"]["id"], archive_item.facebook_post.facebook_id
    assert_equal @@forki_post.first["id"], archive_item.service_id
    assert_equal @@forki_post.first["post"]["url"], archive_item.facebook_post.url
    assert_equal Time.at(@@forki_post.first["post"]["created_at"]).utc.strftime("%FT%T%:z"), archive_item.facebook_post.posted_at.strftime("%FT%T%:z")

    assert_not_nil archive_item.facebook_post.author
    assert archive_item.facebook_post.number_of_likes.positive?
    assert archive_item.facebook_post.number_of_love_reactions.positive?

    assert_not_nil archive_item.facebook_post.images
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
    forki_post2 = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/a.108824087345859/166370841591183", true)["scrape_result"]
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_post).first.facebook_post
    archive_item2 = Sources::FacebookPost.create_from_forki_hash(forki_post2).first.facebook_post
    assert_equal archive_item.author.name, archive_item2.author.name
  end

  test "assert url can be checked" do
    assert Sources::FacebookPost.can_handle_url?("https://www.facebook.com/MarkZuckerberg/videos/123456789/")
    assert_not Sources::FacebookPost.can_handle_url?("https://www.instagram.com/p/notafakeid/")
  end

  test "assert archive image from facebook post" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_post).first
    assert_not_empty archive_item.image_hashes
  end

  test "can archive video from Facebook post" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_facebook_post_video).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item
    assert_not_nil archive_item.facebook_post.videos
  end

  test "dhash properly generated from image" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_post).first
    assert_not_nil archive_item.image_hashes.first.dhash
  end

  test "archiving a video creates a preview screenshot" do
    archive_item = Sources::FacebookPost.create_from_forki_hash(@@forki_facebook_post_video).first
    assert_not_nil archive_item.facebook_post.videos.first.video_derivatives[:preview]
  end
end
