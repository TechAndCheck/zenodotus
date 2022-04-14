require "test_helper"

class InstagramUserTest < ActiveSupport::TestCase
  def setup
    @zorki_user = InstagramMediaSource.extract(
      "https://www.instagram.com/p/CQDeYPhMJLG/", true
    )["scrape_result"].first["post"]["user"]
  end

  def teardown
    if File.exist?("tmp/zorki") && File.directory?("tmp/zorki")
      FileUtils.rm_r "tmp/zorki"
    end
  end

  test "can create instagram user" do
    archive_entity = Sources::InstagramUser.create_from_zorki_hash([@zorki_user]).first
    assert_not_nil archive_entity
    assert_kind_of ArchiveEntity, archive_entity

    assert_equal @zorki_user["username"], archive_entity.instagram_user.handle
    assert_equal @zorki_user["name"], archive_entity.instagram_user.display_name
    assert_equal @zorki_user["username"], archive_entity.service_id
    assert_equal @zorki_user["profile_link"], archive_entity.instagram_user.url

    # I have NO idea why this isn't working using dot-style access, but it's not, so we'll keep it
    # like this for awhile
    assert_equal @zorki_user["profile_image_url"], archive_entity.instagram_user[:profile_image_url]
    assert_equal @zorki_user["number_of_followers"], archive_entity.instagram_user.followers_count
    assert_equal @zorki_user["number_of_following"], archive_entity.instagram_user.following_count

    assert_not_nil archive_entity.instagram_user.profile_image
  end

  test "can update instagram user" do
    archive_entity = Sources::InstagramUser.create_from_zorki_hash([@zorki_user]).first

    # Set a property to something random
    archive_entity.instagram_user.update!({ followers_count: 2 })
    assert_equal archive_entity.instagram_user.followers_count, 2
    # Now try and save it again, and make sure the followers count is correct
    archive_entity2 = Sources::InstagramUser.create_from_zorki_hash([@zorki_user]).first.instagram_user
    assert_equal archive_entity.service_id, archive_entity2.service_id
    assert_equal @zorki_user["number_of_followers"], archive_entity2.followers_count
  end
end
