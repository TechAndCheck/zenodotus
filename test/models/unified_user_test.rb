require "test_helper"
# require "ActiveJob::TestHelper::TestQueueAdapter"

class UnifiedUserTest < ActionController::TestCase
  include ActiveJob::TestHelper

  test "adding_tweet_refreshes_unified_user_view" do
    Sources::Tweet.create_from_url "https://twitter.com/scottwongDC/status/1415040665596084237"
    assert_enqueued_with(job: UnifiedTableRefreshJob)
    perform_enqueued_jobs
    assert_performed_jobs 1
    assert_equal UnifiedUser.all.length, 1
  end
end
