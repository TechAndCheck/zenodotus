# typed: ignore

require "test_helper"

class TweetTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include Minitest::Hooks

  def before_all
    @@birdsong_tweet = TwitterMediaSource.extract("https://twitter.com/NYCSanitation/status/1517229098795515906?s=20&t=MJ1KtW5vuzW6Pxs5IJGdDw")
    @@birdsong_tweet_2 = TwitterMediaSource.extract("https://twitter.com/NYCSanitation/status/1517093299298963456?s=20&t=MJ1KtW5vuzW6Pxs5IJGdDw")
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

  test "can create tweet" do
    archive_item = Sources::Tweet.create_from_birdsong_hash(@@birdsong_tweet).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item

    assert_equal @@birdsong_tweet.first.text, archive_item.tweet.text
    assert_equal @@birdsong_tweet.first.id, archive_item.tweet.twitter_id
    assert_equal @@birdsong_tweet.first.id, archive_item.service_id
    assert_equal @@birdsong_tweet.first.language, archive_item.tweet.language
    assert_equal @@birdsong_tweet.first.created_at, archive_item.tweet.posted_at

    assert_not_nil archive_item.tweet.author
    assert_not_nil archive_item.tweet.images
  end

  test "can archive Tweet from url" do
    tweet = Sources::Tweet.create_from_url("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
    tweet_2 = Sources::Tweet.create_from_url("https://twitter.com/Citruscrush/status/1094999286281048070?fbclid=IwAR20aObVHvlSdu-e2L2mTHXytMqgoGvH6tur4vLz0bU4E2p5k4NciEOAgiE")
    assert_not_nil tweet
    assert_not_nil tweet_2
  end

  test "can archive tweet from url using ActiveJob" do
    Sources::Tweet.create_from_url!("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
    Sources::Tweet.create_from_url!("https://twitter.com/Citruscrush/status/1094999286281048070?fbclid=IwAR20aObVHvlSdu-e2L2mTHXytMqgoGvH6tur4vLz0bU4E2p5k4NciEOAgiE")
    perform_enqueued_jobs

    tweet_1 = Sources::Tweet.where(twitter_id: "1397922363551870990").first
    tweet_2 = Sources::Tweet.where(twitter_id: "1094999286281048070").first

    assert_not_nil tweet_1
    assert_not_nil tweet_2
  end

  test "can create two tweets from same author" do
    archive_item = Sources::Tweet.create_from_birdsong_hash(@@birdsong_tweet).first.tweet
    archive_item2 = Sources::Tweet.create_from_birdsong_hash(@@birdsong_tweet_2).first.tweet

    assert_equal archive_item.author, archive_item2.author
  end

  test "assert url can be checked" do
    assert Sources::Tweet.can_handle_url?("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
    assert_not Sources::Tweet.can_handle_url?("https://twitter.com/AmtrakNECAlerts/status")
  end

  test "assert archive image from tweet" do
    archive_item = Sources::Tweet.create_from_birdsong_hash(@@birdsong_tweet).first
    assert_not_empty archive_item.image_hashes
  end

  test "can archive video from tweet" do
    birdsong_tweet_video = TwitterMediaSource.extract("https://twitter.com/JoeBiden/status/1258817692448051200")
    archive_item = Sources::Tweet.create_from_birdsong_hash(birdsong_tweet_video).first
    assert_not_nil archive_item
    assert_kind_of ArchiveItem, archive_item
    assert_not_nil archive_item.tweet.videos
  end

  test "dhash properly generated from image" do
    birdsong_image_tweet = TwitterMediaSource.extract("https://twitter.com/Bucks/status/1412471909296578563")
    archive_item = Sources::Tweet.create_from_birdsong_hash(birdsong_image_tweet).first
    assert_not_nil archive_item.image_hashes.first.dhash
  end

  test "dhashes properly generated from video" do
    birdsong_image_tweet = TwitterMediaSource.extract("https://twitter.com/JoeBiden/status/1258817692448051200")
    archive_item = Sources::Tweet.create_from_birdsong_hash(birdsong_image_tweet).first
    assert_not archive_item.image_hashes.empty?
    archive_item.image_hashes.each do |hash|
      assert_not_nil hash.dhash
    end
  end

  test "archiving a video creates a preview screenshot" do
    birdsong_tweet_video = TwitterMediaSource.extract("https://twitter.com/JoeBiden/status/1258817692448051200")
    archive_item = Sources::Tweet.create_from_birdsong_hash(birdsong_tweet_video).first
    assert_not_nil archive_item.tweet.videos.first.video_derivatives[:preview]
  end
end
