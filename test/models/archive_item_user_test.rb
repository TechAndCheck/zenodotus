require "test_helper"

class ArchiveItemUserTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

  def setup
    unless defined? @@archive_item
      @@zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    end
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

  test "creating an archive item user works" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first
    archive_item_user = ArchiveItemUser.create(archive_item: archive_item, user: users(:user))
    assert_predicate archive_item_user, :valid?
  end

  test "creating an archive item user with a user that doesn't exist fails" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first
    archive_item_user = ArchiveItemUser.create(archive_item: archive_item, user: nil)
    assert_predicate archive_item_user, :invalid?
  end

  test "creating an archive item user with an archive item that doesn't exist fails" do
    archive_item_user = ArchiveItemUser.create(archive_item: nil, user: users(:user))
    assert_predicate archive_item_user, :invalid?
  end

  test "creating an archive item user with a user and archive item that don't exist fails" do
    archive_item_user = ArchiveItemUser.create(archive_item: nil, user: nil)
    assert_predicate archive_item_user, :invalid?
  end

  test "deleting an archive item deletes the archive item user" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first

    archive_item_user = ArchiveItemUser.create(archive_item: archive_item, user: users(:user))
    assert_predicate archive_item_user, :valid?

    archive_item.destroy
    assert_nil ArchiveItemUser.find_by(id: archive_item_user.id)
  end

  test "creating an archive item user with a user and archive item that already exist fails" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first
    archive_item_user = ArchiveItemUser.create(archive_item: archive_item, user: users(:user))
    assert_predicate archive_item_user, :valid?

    assert_raises ActiveRecord::RecordNotUnique do
      archive_item_user = ArchiveItemUser.create(archive_item: archive_item, user: users(:user))
    end
  end

  test "creating and archive item user means a user has one more archive item" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first
    archive_item_user = ArchiveItemUser.create(archive_item: archive_item, user: users(:user))
    assert_predicate archive_item_user, :valid?

    assert_equal 1, users(:user).archive_items.count
  end

  test "create an archive item user means an archive item has one more user" do
    archive_item = Sources::InstagramPost.create_from_zorki_hash(@@zorki_image_post).first
    archive_item_user = ArchiveItemUser.create(archive_item: archive_item, user: users(:user))
    assert_predicate archive_item_user, :valid?

    assert_equal 1, archive_item.users.count
  end
end
