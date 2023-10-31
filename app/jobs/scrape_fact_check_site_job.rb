class ScrapeFactCheckSiteJob < ApplicationJob
  queue_as :default

  def perform(url)
    ClaimReviewSpider.parse!(:parse, url: url)
  end
end
