# typed: false
require "test_helper"

class MediaModelsTweetTest < ActiveSupport::TestCase
  def setup
  end

  def teardown
  end

  def test_create_media_model_tweet_works
    assert_not_nil Tweet.create()
    assert Tweet.create(
      twitter_id: 123,
      text: "This is a test",
      language: "en"
    ).save
  end
end
