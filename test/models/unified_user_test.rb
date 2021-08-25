require "test_helper"

class UnifiedUserTest < ActiveSupport::TestCase
  test "adding_tweet_refreshes_unified_user_view" do
    Tweet.create_from_url "https://twitter.com/scottwongDC/status/1415040665596084237"
    assert_equal UnifiedUser.all.length, 1
  end
end
