class ScrapeFactCheckSiteJob < ApplicationJob
  queue_as :web_scrapes
  sidekiq_options retry: false

  discard_on Exception do |job, error|
    Honeybadger.notify(error) # This is a last ditch if something goes wrong
  end


  def perform(start_url: nil, scrapable_site: nil, links_visited: nil, link_stack: nil, backoff_time: 0)
    ClaimReviewMech.new.process(
      start_url: start_url,
      scrapable_site: scrapable_site,
      links_visited: links_visited,
      link_stack: link_stack,
      backoff_time: backoff_time
    )
  end
end
