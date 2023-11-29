class ScrapeFactCheckSiteJob < ApplicationJob
  queue_as :web_scrapes

  def perform(scrapable_site)
    ClaimReviewMech.new.process(scrapable_site: scrapable_site)
  end
end
