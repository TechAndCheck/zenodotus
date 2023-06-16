require "test_helper"

class IngestJobTest < ActiveJob::TestCase
  test "invalid url raises error" do
    assert_raises(RuntimeError) do
      ScraperJob.perform_now(TwitterMediaSource, Sources::Tweet, "https://www.example.com", users(:user))
    end
  end
end
