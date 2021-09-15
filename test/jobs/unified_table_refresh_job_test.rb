require "test_helper"

class UnifiedTableRefreshJobTest < ActiveJob::TestCase
  test "adding_tweet_runs_unified_table_refresh_job" do
    assert_enqueued_with(job: UnifiedTableRefreshJob) do
      Sources::Tweet.create_from_url "https://twitter.com/gelliottmorris/status/1415035023691075594"
    end
  end
end
