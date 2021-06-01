require "test_helper"

class TwitterUserTest < ActiveSupport::TestCase
  def setup
    @birdsong_user = TwitterMediaSource.extract("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990").first.author
  end

  test "can create tweet" do
    media_item = TwitterUser.create_from_birdsong_hash([@birdsong_user]).first
    assert_not_nil media_item
    assert_kind_of MediaItem, media_item

    assert_equal @birdsong_user.username, media_item.twitter_user.handle
    assert_equal @birdsong_user.name, media_item.twitter_user.display_name
    assert_equal @birdsong_user.id, media_item.service_id
    assert_equal @birdsong_user.created_at, media_item.twitter_user.sign_up_date
    assert_equal @birdsong_user.url, media_item.twitter_user.url

    # I have NO idea why this isn't working using dot-style access, but it's not, so we'll keep it
    # like this for awhile
    assert_equal @birdsong_user.profile_image_url, media_item.twitter_user[:profile_image_url]
    assert_equal @birdsong_user.location, media_item.twitter_user.location

    assert_not_nil media_item.twitter_user.profile_image
  end
end
