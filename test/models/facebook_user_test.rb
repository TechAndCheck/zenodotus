require "test_helper"

class FacebookUserTest < ActiveSupport::TestCase
  include Minitest::Hooks

  def before_all
    @@forki_user = FacebookMediaSource.extract(
      "https://www.facebook.com/Meta/photos/a.108824087345859/336596487901950", true
    )["scrape_result"].first["post"]["user"]
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

  test "can create facebook user" do
    archive_entity = Sources::FacebookUser.create_from_forki_hash([@@forki_user]).first
    assert_not_nil archive_entity
    assert_kind_of ArchiveEntity, archive_entity

    assert_equal @@forki_user["name"], archive_entity.facebook_user.name
    assert_equal @@forki_user["verified"], archive_entity.facebook_user.verified
    assert_equal @@forki_user["profile_link"], archive_entity.facebook_user.url

    # I have NO idea why this isn't working using dot-style access, but it's not, so we'll keep it
    # like this for awhile
    assert_equal @@forki_user["profile_image_url"], archive_entity.facebook_user[:profile_image_url]
    assert_equal @@forki_user["number_of_followers"], archive_entity.facebook_user.followers_count

    assert_not_nil archive_entity.facebook_user.profile_image
  end

  test "Can update facebook user" do
    archive_entity = Sources::FacebookUser.create_from_forki_hash([@@forki_user]).first

    # Set a property to something random
    archive_entity.facebook_user.update!({ followers_count: 2 })
    assert_equal archive_entity.facebook_user.followers_count, 2
    # Now try and save it again, and make sure the followers count is correct
    archive_entity2 = Sources::FacebookUser.create_from_forki_hash([@@forki_user]).first.facebook_user
    assert_equal archive_entity.service_id, archive_entity2.service_id
    assert_equal @@forki_user["number_of_followers"], archive_entity2.followers_count
  end

  test "can update facebook user" do
    archive_entity = Sources::FacebookUser.create_from_forki_hash([@@forki_user]).first

    # Set a property to something random
    archive_entity.facebook_user.update!({ followers_count: 2 })
    assert_equal archive_entity.facebook_user.followers_count, 2
    # Now try and save it again, and make sure the followers count is correct
    archive_entity2 = Sources::FacebookUser.create_from_forki_hash([@@forki_user]).first.facebook_user
    assert_equal archive_entity.service_id, archive_entity2.service_id
    assert_equal @@forki_user["number_of_followers"], archive_entity2.followers_count
  end
end
