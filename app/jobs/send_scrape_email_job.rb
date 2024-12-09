class SendScrapeEmailJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 2.minutes, attempts: 5

  def perform(scrape)
    logger.info "Sending completion email for scrape #{scrape.id}"
    scrape.send_completion_email
  end
end
