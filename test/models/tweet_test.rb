# typed: false
require "test_helper"

class TweetTest < ActiveSupport::TestCase
  def setup
    @birdsong_tweet = TwitterMediaSource.extract("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
    @birdsong_tweet2 = TwitterMediaSource.extract("https://twitter.com/AmtrakNECAlerts/status/1400055826170191874")
  end

  test "can create tweet" do
    archive_item = Tweet.create_from_birdsong_hash(@birdsong_tweet).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item

    assert_equal @birdsong_tweet.first.text, archive_item.tweet.text
    assert_equal @birdsong_tweet.first.id, archive_item.tweet.twitter_id
    assert_equal @birdsong_tweet.first.id, archive_item.service_id
    assert_equal @birdsong_tweet.first.language, archive_item.tweet.language
    assert_equal @birdsong_tweet.first.created_at, archive_item.tweet.posted_at

    assert_not_nil archive_item.tweet.author
  end

  test "can create two tweets from same author" do
    archive_item = Tweet.create_from_birdsong_hash(@birdsong_tweet).first.tweet
    archive_item2 = Tweet.create_from_birdsong_hash(@birdsong_tweet2).first.tweet

    assert_equal archive_item.author, archive_item2.author
  end
end
