# require "test_helper"

# class CrawlableSiteTest < ActiveSupport::TestCase
#   test "a crawlable site returns the correct url to start" do
#     crawlable_site = crawlable_sites(:one)
#     assert_equal "https://www.example.com", crawlable_site.url_to_scrape

#     crawlable_site = crawlable_sites(:two)
#     assert_equal "https://example.com/latest", crawlable_site.url_to_scrape
#   end

#   test "a crawlable site can be marked as started" do
#     crawlable_site = crawlable_sites(:one)
#     assert_nil(crawlable_site.last_run)

#     crawlable_site.scrape!
#     assert_not_nil(crawlable_site.last_run)
#   end

#   test "a crawlable site can be checked in with" do
#     crawlable_site = crawlable_sites(:one)
#     assert_nil(crawlable_site.last_heartbeat_at)

#     crawlable_site.checkin
#     assert_not_nil(crawlable_site.last_heartbeat_at)
#   end

#   test "a crawlable site can be finished" do
#     crawlable_site = crawlable_sites(:one)
#     assert_nil(crawlable_site.last_run_finished_at)

#     crawlable_site.finish_scrape
#     assert_not_nil(crawlable_site.last_run_finished_at)
#     assert_not_nil(crawlable_site.last_run_time)
#   end

#   test "a crawlable site can be marked as running" do
#     crawlable_site = crawlable_sites(:one)
#     crawlable_site.scrape!

#     assert_predicate(crawlable_site, :running?)
#   end

#   test "a crawlable site can be marked as running after a previous run" do
#     crawlable_site = crawlable_sites(:one)
#     crawlable_site.scrape!

#     assert_not(crawlable_site.running?)

#     crawlable_site.update({ last_heartbeat_at: Time.now })
#     assert_predicate(crawlable_site, :running?)
#   end

#   test "a crawlable site is not stalled until heartbeat doesn't check in for 10 minutes" do
#     crawlable_site = crawlable_sites(:one)
#     crawlable_site.scrape!

#     # We go back a bit in time
#     crawlable_site.update({ last_heartbeat_at: Time.now - 9.minutes })
#     assert_not(crawlable_site.stalled?)
#   end

#   test "a crawlable site is stalled if heartbeat hasn't been checked in for at least 10 minutes" do
#     crawlable_site = crawlable_sites(:one)
#     crawlable_site.scrape!

#     # Now we go back in time even more
#     crawlable_site.update({ last_heartbeat_at: Time.now - 11.minutes })
#     assert_predicate(crawlable_site, :stalled?)
#   end

#   test "a crawlable site returns correct emoji for status" do
#     crawlable_site = crawlable_sites(:one)
#     assert_equal("⚪", crawlable_site.emoji_for_status)

#     crawlable_site.scrape!
#     assert_equal("🟢", crawlable_site.emoji_for_status)

#     crawlable_site.update({ last_heartbeat_at: Time.now - 11.minutes })
#     assert_equal("🔴", crawlable_site.emoji_for_status)
#   end
# end
