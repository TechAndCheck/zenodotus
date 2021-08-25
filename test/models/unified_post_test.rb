require "test_helper"

class UnifiedPostTest < ActiveSupport::TestCase
  test "adding_tweet_refreshes_unified_post_view" do
    Sources::Tweet.create_from_url "https://twitter.com/scottwongDC/status/1415040665596084237"
    assert_equal UnifiedPost.all.length, 1
  end
end
