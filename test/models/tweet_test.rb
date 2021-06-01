# typed: false
require "test_helper"

class TweetTest < ActiveSupport::TestCase
  def setup
    @birdsong_tweet = TwitterMediaSource.extract("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
  end

  test "can create tweet" do
    media_item = Tweet.create_from_birdsong_hash(@birdsong_tweet).first
    assert_not_nil media_item
    assert_kind_of MediaItem, media_item

    assert_equal @birdsong_tweet.first.text, media_item.tweet.text
    assert_equal @birdsong_tweet.first.id, media_item.tweet.twitter_id
    assert_equal @birdsong_tweet.first.id, media_item.service_id
    assert_equal @birdsong_tweet.first.language, media_item.tweet.language

    assert_not_nil media_item.tweet.author
  end
end
