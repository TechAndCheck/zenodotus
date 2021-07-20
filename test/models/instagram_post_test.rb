require "test_helper"

class InstagramPostTest < ActiveSupport::TestCase
  def setup
    @zorki_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed")
  end

  def teardown
    if File.exist?("tmp/zorki") && File.directory?("tmp/zorki")
      FileUtils.rm_r "tmp/zorki"
    end
  end

  test "can create Instagram post" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@zorki_post).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item

    assert_equal @zorki_post.first.text, archive_item.instagram_post.text
    assert_equal @zorki_post.first.id, archive_item.instagram_post.instagram_id
    assert_equal @zorki_post.first.id, archive_item.service_id
    assert_equal @zorki_post.first.date, archive_item.instagram_post.posted_at

    assert_not_nil archive_item.instagram_post.author
    assert_not_nil archive_item.instagram_post.images
  end

  test "can create from Instagram url" do
    assert_not_nil Sources::InstagramPost.create_from_url("https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed")
  end

  test "can create two tweets from same author" do
    @zorki_post2 = InstagramMediaSource.extract("https://www.instagram.com/p/CQDeYPhMJLG/")
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@zorki_post).first.instagram_post
    archive_item2 = Sources::InstagramPost.create_from_zorki_hash(@zorki_post2).first.instagram_post
    assert_equal archive_item.author, archive_item2.author
  end

  test "assert_url_can_be_checked" do
    assert Sources::InstagramPost.can_handle_url?("https://www.instagram.com/p/CQDeYPhMJLG/")
    assert_not Sources::InstagramPost.can_handle_url?("https://www.instagram.com/z/CQDeYPhMJLG/")
  end

  test "can archive video from Instagram post" do
    zorki_instagram_post_video = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/?utm_source=ig_embed")
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_instagram_post_video).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item
    assert_not_nil archive_item.instagram_post.videos
  end

  test "dhash properly generated from image" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@zorki_post).first
    assert_not_nil archive_item.instagram_post.images.first.dhash
  end

  test "archiving a video creates a preview screenshot" do
    zorki_instagram_post_video = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/?utm_source=ig_embed")
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_instagram_post_video).first
    assert_not_nil archive_item.instagram_post.videos.first.video_derivatives[:preview]
  end
end
