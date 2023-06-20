require "test_helper"

class ScrapeJobTest < ActiveJob::TestCase
  test "a scrape job can perform" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram
    })

    ScrapeJob.perform_now(scrape)
  end
end
