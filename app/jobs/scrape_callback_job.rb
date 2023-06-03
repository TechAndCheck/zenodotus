class ScrapeCallbackJob < ApplicationJob
  queue_as :default

  # Type is :media_review or :claim_review
  def perform(scrape, parsed_result)
    scrape
    scrape.fulfill(parsed_result)
  end
end
