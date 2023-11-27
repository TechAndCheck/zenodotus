require "test_helper"

class ScrapableSiteTest < ActiveSupport::TestCase
  test "a scrapable site returns the correct url to start" do
    scrapable_site = scrapable_sites(:one)
    assert_equal "https://www.example.com", scrapable_site.url_to_scrape

    scrapable_site = scrapable_sites(:two)
    assert_equal "https://example.com/latest", scrapable_site.url_to_scrape
  end

  test "a scrapable site can be marked as started" do
    scrapable_site = scrapable_sites(:one)
    assert_nil(scrapable_site.last_run)

    scrapable_site.scrape!
    assert_not_nil(scrapable_site.last_run)
  end

  test "a scrapable site can be checked in with" do
    scrapable_site = scrapable_sites(:one)
    assert_nil(scrapable_site.last_heartbeat_at)

    scrapable_site.checkin
    assert_not_nil(scrapable_site.last_heartbeat_at)
  end

  test "a scrapable site can be finished" do
    scrapable_site = scrapable_sites(:one)
    assert_nil(scrapable_site.last_run_finished_at)

    scrapable_site.finish_scrape
    assert_not_nil(scrapable_site.last_run_finished_at)
    assert_not_nil(scrapable_site.last_run_time)
  end

  test "a scrapable site can be marked as running" do
    scrapable_site = scrapable_sites(:one)
    scrapable_site.scrape!

    assert(scrapable_site.running?)
  end

  test "a scrapable site can be marked as running after a previous run" do
    scrapable_site = scrapable_sites(:one)
    scrapable_site.scrape!

    assert_not(scrapable_site.running?)

    scrapable_site.update({ last_heartbeat_at: Time.now })
    assert(scrapable_site.running?)
  end

  test "a scrapable site is not stalled until heartbeat doesn't check in for 10 minutes" do
    scrapable_site = scrapable_sites(:one)
    scrapable_site.scrape!

    # We go back a bit in time
    scrapable_site.update({ last_heartbeat_at: Time.now - 9.minutes })
    assert_not(scrapable_site.stalled?)
  end

  test "a scrapable site is stalled if heartbeat hasn't been checked in for at least 10 minutes" do
    scrapable_site = scrapable_sites(:one)
    scrapable_site.scrape!

    # Now we go back in time even more
    scrapable_site.update({ last_heartbeat_at: Time.now - 11.minutes })
    assert(scrapable_site.stalled?)
  end

  test "a scrapable site returns correct emoji for status" do
    scrapable_site = scrapable_sites(:one)
    assert_equal("⚪", scrapable_site.emoji_for_status)

    scrapable_site.scrape!
    assert_equal("🟢", scrapable_site.emoji_for_status)

    scrapable_site.update({ last_heartbeat_at: Time.now - 11.minutes })
    assert_equal("🔴", scrapable_site.emoji_for_status)
  end
end
