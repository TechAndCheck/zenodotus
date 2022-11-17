# typed: ignore

require "test_helper"

class TwitterUserTest < ActiveSupport::TestCase
  include Minitest::Hooks

  def before_all
    @birdsong_user = TwitterMediaSource.extract(
      "https://twitter.com/AmtrakNECAlerts/status/1397922363551870990", true
    )["scrape_result"].first["post"]["author"]
  end

  def after_all
    if File.exist?("tmp") && File.directory?("tmp")
      FileUtils.rm_r("tmp")
    end
  end

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  test "can create twitter user" do
    archive_entity = Sources::TwitterUser.create_from_birdsong_hash([@birdsong_user]).first
    assert_not_nil archive_entity
    assert_kind_of ArchiveEntity, archive_entity

    assert_equal @birdsong_user["username"], archive_entity.twitter_user.handle
    assert_equal @birdsong_user["name"], archive_entity.twitter_user.display_name
    assert_equal @birdsong_user["id"], archive_entity.service_id
    created_at = Time.strptime(@birdsong_user["created_at"], "%Y-%m-%dT%H:%M:%S%z")
    assert_equal created_at, archive_entity.twitter_user.sign_up_date
    assert_equal @birdsong_user["url"], archive_entity.twitter_user.url

    # I have NO idea why this isn't working using dot-style access, but it's not, so we'll keep it
    # like this for awhile
    assert_equal @birdsong_user["profile_image_url"], archive_entity.twitter_user[:profile_image_url]
    assert_equal @birdsong_user["location"], archive_entity.twitter_user.location
    assert_equal @birdsong_user["following_count"], archive_entity.twitter_user.following_count
    assert_equal @birdsong_user["followers_count"], archive_entity.twitter_user.followers_count

    assert_not_nil archive_entity.twitter_user.profile_image
  end

  test "can update twitter user" do
    archive_entity = Sources::TwitterUser.create_from_birdsong_hash([@birdsong_user]).first

    # Set a property to something random
    archive_entity.twitter_user.update!({ followers_count: 2 })
    assert_equal archive_entity.twitter_user.followers_count, 2
    # Now try and save it again, and make sure the followers count is correct
    archive_entity2 = Sources::TwitterUser.create_from_birdsong_hash([@birdsong_user]).first.twitter_user
    assert_equal archive_entity.service_id, archive_entity2.service_id
    assert_equal @birdsong_user["followers_count"], archive_entity2.followers_count
  end

  test "can get correct platform from author" do
    author = sources_twitter_users(:twitter_user)

    assert_equal "twitter", author.platform
  end
end
