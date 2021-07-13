require "test_helper"

class UnifiedUserTest < ActiveSupport::TestCase
  test "adding_tweet_refreshes_unified_user_view" do
    init_view_size = UnifiedUser.all.length
    expected_view_size = init_view_size + 1
    Tweet.create_from_url "https://twitter.com/BillAdairDuke/status/1217942366721466369"
    assert_equal UnifiedUser.all.length, expected_view_size
  end
end
