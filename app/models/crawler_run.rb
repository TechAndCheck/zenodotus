class CrawlerRun < ApplicationRecord
  # t.string :starting_url, null: false, unique: true
  # t.string :host_name, null: false, unique: true
  # t.timestamp :started_at
  # t.timestamp :finished_at
  # t.integer :number_of_pages_scraped, default: 0
  # t.integer :number_of_new_claims_found, default: 0
  # t.timestamps

  # validations
  validates :starting_url, presence: true
  validates :host_name, presence: true
  validates :started_at, presence: true
  # validates :number_of_pages_scraped, greater_than_or_equal_to: 0
  # validates :number_of_new_claims_found, greater_than_or_equal_to: 0

  def pages
    Page.where(scrape_run: self)
  end

  def start
    self.update(started_at: Time.now)
  end

  def finish
    self.update(finished_at: Time.now)
  end

  def elapsed_time
    return 0 unless started_at
    return Time.now - started_at unless finished_at
    finished_at - started_at
  end
end
