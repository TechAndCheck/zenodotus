class ScraperJob < ApplicationJob
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

  def perform(media_source_class, media_model, url, user)
    puts "Beginning to scrape #{url} @ #{Time.now}"
    media_item = media_source_class.extract(url)

    # If a scraper runs locally we can't create the actual model from the callback, so we do it now
    media_model.create_from_hash(media_item, user) if media_source_class.runs_scraper_locally?

    puts "Done scraping #{url} @ #{Time.now}"
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
