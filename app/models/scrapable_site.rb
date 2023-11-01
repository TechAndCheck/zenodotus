class ScrapableSite < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true

  def scrape(time_to_wait = 0.minutes)
    # Kick off a job
    ScrapeFactCheckSiteJob.set(wait: time_to_wait).perform_later(self.url_to_scrape)
    set_last_run_to_now
  end

  # This is only for testing, do NOT use in production, it's blocking. That's bad
  def scrape!
    logger.info "*************************STOP************************************************"
    logger.info "You're calling a scraper in a blocking way, that's usually NOT what you want."
    logger.info "Use `.scrape` instead of `.scrape!` trust Chris on this."
    logger.info "*************************STOP************************************************"
    ScrapeFactCheckSiteJob.perform_now(self.url_to_scrape)
    set_last_run_to_now
  end

  def url_to_scrape
    self.starting_url.nil? ? self.url : self.url
  end

  def set_last_run_to_now
    self.update({ last_run: Time.now })
  end
end
