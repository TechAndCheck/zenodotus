require "test_helper"

class ScrapeFactCheckSite::ScrapeJobTest < ActiveJob::TestCase
  test "can enqueue a scrape job" do
    assert_enqueued_with(job: ScrapeFactCheckSite::ScrapeJob) do
      ScrapeFactCheckSite::ScrapeJob.perform_later
    end
  end

  test "can enqueue a scrape job with a crawlable site" do
    crawlable_site = crawlable_sites(:one)
    assert_enqueued_with(job: ScrapeFactCheckSite::ScrapeJob) do
      ScrapeFactCheckSite::ScrapeJob.perform_later(crawlable_site: crawlable_site)
    end
  end

  test "can enqueue a scrape job with a crawlable site and backoff time" do
    crawlable_site = crawlable_sites(:one)
    backoff_time = 5
    assert_enqueued_with(job: ScrapeFactCheckSite::ScrapeJob) do
      ScrapeFactCheckSite::ScrapeJob.perform_later(crawlable_site: crawlable_site, backoff_time: backoff_time)
    end
  end

  test "a job properly starts up everything" do
    crawlable_site = crawlable_sites(:one)

    perform_enqueued_jobs do
      ScrapeFactCheckSite::ScrapeJob.perform_later(crawlable_site: crawlable_site)
    end
    assert_performed_jobs 1

    assert_equal 1, CrawledPage.count
  end
end
