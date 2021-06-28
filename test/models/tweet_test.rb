# typed: ignore
require "test_helper"

class TweetTest < ActiveSupport::TestCase
  def setup
    @birdsong_tweet = TwitterMediaSource.extract("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
    @birdsong_tweet2 = TwitterMediaSource.extract("https://twitter.com/AmtrakNECAlerts/status/1400055826170191874")
  end

  def teardown
    if File.exist?("tmp/birdsong") && File.directory?("tmp/birdsong")
      FileUtils.rm_r "tmp/birdsong"
    end
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
    assert_not_nil archive_item.tweet.images
  end

  test "can create from Tweet url" do
    assert_not_nil Tweet.create_from_url("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
    # a slightly different URL
    assert_not_nil Tweet.create_from_url("https://twitter.com/Citruscrush/status/1094999286281048070?fbclid=IwAR20aObVHvlSdu-e2L2mTHXytMqgoGvH6tur4vLz0bU4E2p5k4NciEOAgiE")
  end

  test "can create two tweets from same author" do
    archive_item = Tweet.create_from_birdsong_hash(@birdsong_tweet).first.tweet
    archive_item2 = Tweet.create_from_birdsong_hash(@birdsong_tweet2).first.tweet

    assert_equal archive_item.author, archive_item2.author
  end

  test "assert url can be checked" do
    assert Tweet.can_handle_url?("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
    assert_not Tweet.can_handle_url?("https://twitter.com/AmtrakNECAlerts/status")
  end

  test "can archive video from tweet" do
    birdsong_tweet_video = TwitterMediaSource.extract("https://twitter.com/JoeBiden/status/1258817692448051200")
    archive_item = Tweet.create_from_birdsong_hash(birdsong_tweet_video).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item
    assert_not_nil archive_item.tweet.videos
  end
end
