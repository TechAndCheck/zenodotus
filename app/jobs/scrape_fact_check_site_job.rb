class ScrapeFactCheckSiteJob < ApplicationJob
  queue_as :default

  def perform(url)
    ClaimReviewMech.new.process(url)
  end
end
