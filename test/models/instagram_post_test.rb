require "test_helper"

class InstagramPostTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  @@zorki_image_post = nil
  @@zorki_video_post = nil

  def setup
    @@zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", true)["scrape_result"] if @@zorki_image_post.nil?
    @@zorki_video_post = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/", true)["scrape_result"] if @@zorki_video_post.nil?
  end

  def teardown
    if File.exist?("tmp/zorki") && File.directory?("tmp/zorki")
      FileUtils.rm_r "tmp/zorki"
    end
  end

  test "can create Instagram post" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item

    assert_equal @@zorki_image_post.first["post"]["text"], archive_item.instagram_post.text
    assert_equal @@zorki_image_post.first["id"], archive_item.instagram_post.instagram_id
    assert_equal @@zorki_image_post.first["id"], archive_item.service_id
    assert_equal @@zorki_image_post.first["post"]["date"], archive_item.instagram_post.posted_at.strftime("%FT%T%:z")

    assert_not_nil archive_item.instagram_post.author
    assert_not_nil archive_item.instagram_post.images
  end

  test "can create from Instagram url" do
    assert_not_nil Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CBcqOkyDDH8/")
  end

  test "can create from Instagram url using ActiveJob" do
    assert_enqueued_jobs 0
    assert Sources::InstagramPost.create_from_url("https://www.instagram.com/p/CBcqOkyDDH8/")
    assert_enqueued_jobs 1

    assert_nothing_raised do
      perform_enqueued_jobs
    end
  end

  test "can create two Instagram posts from same author" do
    zorki_post2 = InstagramMediaSource.extract("https://www.instagram.com/p/CQDeYPhMJLG/", true)["scrape_result"]
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first.instagram_post
    archive_item2 = Sources::InstagramPost.create_from_zorki_hash(zorki_post2).first.instagram_post
    assert_equal archive_item.author, archive_item2.author
  end

  test "assert_url_can_be_checked" do
    assert Sources::InstagramPost.can_handle_url?("https://www.instagram.com/p/CQDeYPhMJLG/")
    assert_not Sources::InstagramPost.can_handle_url?("https://www.instagram.com/z/CQDeYPhMJLG/")
  end

  test "can kick off archive from Instagram post" do
    result = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/", true)
    assert result
  end

  test "assert archive image from Instagram post" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first
    assert_not_empty archive_item.image_hashes
  end

  test "can archive video from Instagram post" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_video_post)
    assert_not_nil archive_item
    assert_kind_of Array, archive_item
    assert_not_nil archive_item.first
    assert_not_nil archive_item.first.instagram_post.videos
  end

  test "dhash properly generated from image" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first
    assert_not_nil archive_item.image_hashes.first.dhash
  end

  test "archiving a video creates a preview screenshot" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_video_post).first
    assert_not_nil archive_item.instagram_post.videos.first.video_derivatives[:preview]
  end
end
