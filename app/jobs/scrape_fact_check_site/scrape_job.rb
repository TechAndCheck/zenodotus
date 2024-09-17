class ScrapeFactCheckSite::ScrapeJob < ApplicationJob
  queue_as :web_scrapes
  sidekiq_options retry: false

  discard_on Exception do |job, error|
    Honeybadger.notify(error) # This is a last ditch if something goes wrong
  end


  def perform(crawlable_site: nil, backoff_time: 0)
    ClaimReviewMech.new.process(
      crawlable_site: crawlable_site,
      backoff_time: backoff_time
    )
  end
end
