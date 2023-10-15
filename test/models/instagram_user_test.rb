require "test_helper"

class InstagramUserTest < ActiveSupport::TestCase
  include Minitest::Hooks

  def before_all
    @@zorki_user = InstagramMediaSource.extract("https://www.instagram.com/p/CQDeYPhMJLG/", MediaSource::ScrapeType::Instagram, true)["scrape_result"].first["post"]["user"]
  end

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  def after_all
    if File.exist?("tmp") && File.directory?("tmp")
      FileUtils.rm_r("tmp/")
    end
  end

  test "can create instagram user" do
    archive_entity = Sources::InstagramUser.create_from_zorki_hash([@@zorki_user]).first
    assert_not_nil archive_entity
    assert_kind_of ArchiveEntity, archive_entity

    assert_equal @@zorki_user["username"], archive_entity.instagram_user.handle
    assert_equal @@zorki_user["name"], archive_entity.instagram_user.display_name
    assert_equal @@zorki_user["username"], archive_entity.service_id
    assert_equal @@zorki_user["profile_link"], archive_entity.instagram_user.url

    # I have NO idea why this isn't working using dot-style access, but it's not, so we'll keep it
    # like this for awhile
    assert_equal @@zorki_user["profile_image_url"], archive_entity.instagram_user[:profile_image_url]
    assert_equal @@zorki_user["number_of_followers"], archive_entity.instagram_user.followers_count
    assert_equal @@zorki_user["number_of_following"], archive_entity.instagram_user.following_count

    assert_not_nil archive_entity.instagram_user.profile_image
  end

  test "can update instagram user" do
    archive_entity = Sources::InstagramUser.create_from_zorki_hash([@@zorki_user]).first

    # Set a property to something random
    archive_entity.instagram_user.update!({ followers_count: 2 })
    assert_equal archive_entity.instagram_user.followers_count, 2
    # Now try and save it again, and make sure the followers count is correct
    archive_entity2 = Sources::InstagramUser.create_from_zorki_hash([@@zorki_user]).first.instagram_user
    assert_equal archive_entity.service_id, archive_entity2.service_id
    assert_equal @@zorki_user["number_of_followers"], archive_entity2.followers_count
  end

  test "can get correct platform from author" do
    author = sources_instagram_users(:instagram_user)

    assert_equal "instagram", author.platform
  end
end
