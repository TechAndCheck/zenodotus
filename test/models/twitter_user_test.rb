# typed: ignore
require "test_helper"

class TwitterUserTest < ActiveSupport::TestCase
  def setup
    @birdsong_user = TwitterMediaSource.extract(
      "https://twitter.com/AmtrakNECAlerts/status/1397922363551870990"
    ).first.author
  end

  def teardown
    if File.exist?("tmp/birdsong") && File.directory?("tmp/birdsong")
      FileUtils.rm_r "tmp/birdsong"
    end
  end

  test "can create twitter user" do
    archive_entity = TwitterUser.create_from_birdsong_hash([@birdsong_user]).first
    assert_not_nil archive_entity
    assert_kind_of ArchiveEntity, archive_entity

    assert_equal @birdsong_user.username, archive_entity.twitter_user.handle
    assert_equal @birdsong_user.name, archive_entity.twitter_user.display_name
    assert_equal @birdsong_user.id, archive_entity.service_id
    assert_equal @birdsong_user.created_at, archive_entity.twitter_user.sign_up_date
    assert_equal @birdsong_user.url, archive_entity.twitter_user.url

    # I have NO idea why this isn't working using dot-style access, but it's not, so we'll keep it
    # like this for awhile
    assert_equal @birdsong_user.profile_image_url, archive_entity.twitter_user[:profile_image_url]
    assert_equal @birdsong_user.location, archive_entity.twitter_user.location
    assert_equal @birdsong_user.following_count, archive_entity.twitter_user.following_count
    assert_equal @birdsong_user.followers_count, archive_entity.twitter_user.followers_count

    assert_not_nil archive_entity.twitter_user.profile_image
  end

  test "can update twitter user" do
    archive_entity = TwitterUser.create_from_birdsong_hash([@birdsong_user]).first

    # Set a property to something random
    archive_entity.twitter_user.update!({ followers_count: 2 })
    assert_equal archive_entity.twitter_user.followers_count, 2
    # Now try and save it again, and make sure the followers count is correct
    archive_entity2 = TwitterUser.create_from_birdsong_hash([@birdsong_user]).first.twitter_user
    assert_equal archive_entity.service_id, archive_entity2.service_id
    assert_equal @birdsong_user.followers_count, archive_entity2.followers_count
  end
end
