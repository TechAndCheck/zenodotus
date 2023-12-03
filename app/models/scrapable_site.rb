class ScrapableSite < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true

  def scrape(time_to_wait = 0.minutes)
    # Kick off a job
    ScrapeFactCheckSiteJob.set(wait: time_to_wait).perform_later(scrapable_site: self)
  end

  # This is only for testing, do NOT use in production, it's blocking. That's bad
  def scrape!
    logger.info "*************************STOP************************************************"
    logger.info "You're calling a scraper in a blocking way, that's usually NOT what you want."
    logger.info "Use `.scrape` instead of `.scrape!`"
    logger.info "\n\nTrust Chris on this."
    logger.info "*************************STOP************************************************"
    ScrapeFactCheckSiteJob.perform_now(scrapable_site: self)
  end

  def url_to_scrape
    self.starting_url.nil? ? self.url : self.starting_url
  end

  def set_last_run_to_now
    self.update({ last_run: Time.now })
  end

  def checkin
    self.update({ last_heartbeat_at: Time.now })
  end

  def finish_scrape
    self.update({
      last_run_finished_at: Time.now,
      last_run_time: Time.now.to_i - self.last_run.to_i
    })
  end

  def running?
    # Let's a assume it's not running if there's no heartbeat saved
    return false if self.last_heartbeat_at.blank? || (self.last_run_finished_at.blank? && self.last_run.blank?)
    return true if !self.last_run.blank? && self.last_run_finished_at.blank?

    # We compare with seconds, not with time, because milliseconds don't matter
    self.last_heartbeat_at > self.last_run_finished_at
  end

  def stalled?
    # If we haven't checked in in 10 minutes, it's stalled
    self.running? && self.last_heartbeat_at < Time.now - 10.minutes
  end

  def emoji_for_status
    return "🔴" if self.stalled?
    return "🟢" if self.running?
    "⚪"
  end
end
