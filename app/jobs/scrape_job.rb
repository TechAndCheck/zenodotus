# Moving from ScraperJob to this for better coherence, so that the Scrape model
# is the only thing that encodes this

class ScrapeJob < ApplicationJob
  require "sidekiq/api"

  queue_as :default

  # When a job is placed on the queue, broadcast to update the jobs status page
  after_enqueue do |job|
    ActionCable.server.broadcast("jobs_channel", { jobs_count: Sidekiq::Queue.new.size })
  end

  # When a job is completed, broadcast to update the jobs status page
  after_perform do |job|
    ActionCable.server.broadcast("jobs_channel", { jobs_count: Sidekiq::Queue.new.size })
  end

  def perform(scrape)
    puts "Beginning to scrape #{scrape.url} @ #{Time.now}"
    response = scrape.perform
    raise "Cannot connect to Hypatia" unless response.has_key?("success") && response["success"] == true
    puts "Done scraping #{scrape.url} @ #{Time.now}"
  end

  def get_sidekiq_queue
    Sidekiq::Queue.new.to_a.reverse.each_with_index.map do |job, ind|
      {
        queue_position: ind + 1,
        url: job.item["args"][0]["arguments"].last,
        enqueued_at: Time.at(job.item["enqueued_at"]),
      }
    end
  end
end
