require "test_helper"

class UnifiedPostTest < ActiveSupport::TestCase

  test "adding_tweet_refreshes_unified_post_view" do
    init_view_size = UnifiedPost.all.length
    expected_view_size = init_view_size + 1
    Sources::Tweet.create_from_url "https://twitter.com/scottwongDC/status/1415040665596084237"
    assert_equal UnifiedPost.all.length, expected_view_size
  end
end
