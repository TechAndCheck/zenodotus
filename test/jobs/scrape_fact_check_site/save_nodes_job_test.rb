require "test_helper"

class ScrapeFactCheckSite::SaveNodesJobTest < ActiveJob::TestCase
  def setup
    ActiveGraph::Base.query("MATCH (n) DETACH DELETE n")
  end

  def teardown
    ActiveGraph::Base.query("MATCH (n) DETACH DELETE n")
  end

  def before_all
    ActiveGraph::Base.query("MATCH (n) DETACH DELETE n")
  end

  test "can enqueue a save nodes job" do
    assert_enqueued_with(job: ScrapeFactCheckSite::SaveNodesJob) do
      ScrapeFactCheckSite::SaveNodesJob.perform_later
    end
  end

  test "can enqueue a save nodes job with a crawlable site" do
    crawlable_site = crawlable_sites(:one)
    crawlable_page = CrawledPage.create(url: crawlable_site.url_to_scrape, crawlable_site_id: crawlable_site.id)

    assert_enqueued_with(job: ScrapeFactCheckSite::SaveNodesJob) do
      ScrapeFactCheckSite::SaveNodesJob.perform_later(current_crawler_page_id: crawlable_page.id)
    end
  end

  test "can enqueue a scrape job with a crawlable site and links to save" do
    crawlable_site = crawlable_sites(:one)
    crawlable_page = CrawledPage.create(url: crawlable_site.url_to_scrape, crawlable_site_id: crawlable_site.id)

    links = ["https://www.example.com"]

    assert_enqueued_with(job: ScrapeFactCheckSite::SaveNodesJob) do
      ScrapeFactCheckSite::SaveNodesJob.perform_later(links_to_create: links, current_crawler_page_id: crawlable_page.id)
    end
  end

  test "a job properly starts up everything" do
    crawlable_site = crawlable_sites(:one)
    crawlable_page = CrawledPage.create(url: crawlable_site.url_to_scrape, crawlable_site_id: crawlable_site.id)

    links = ["https://www.example1.com"]

    perform_enqueued_jobs do
      ScrapeFactCheckSite::SaveNodesJob.perform_later(links_to_create: links, current_crawler_page_id: crawlable_page.id)
    end
    assert_performed_jobs 1

    assert_equal 2, CrawledPage.count

    # FIXME: assert_equal 1, CrawledPage.first.crawled_pages_out.count
    # FIXME: assert_equal 1, CrawledPage.last.crawled_pages_in.count
  end
end
