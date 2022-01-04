class ScraperJob < ApplicationJob
  require "sidekiq/api"

  queue_as :default

  # When a job is placed on the queue, broadcast to update the jobs status page
  after_enqueue do |job|
    unless Sidekiq::Queue.new.size.zero?
      queue = get_sidekiq_queue
      ActionCable.server.broadcast("jobs_channel", { jobs: queue })
    end
  end

  # When a job is completed, broadcast to update the jobs status page
  after_perform do |job|
    if Sidekiq::Queue.new.size.zero?
      # Empties jobs status table
      ActionCable.server.broadcast("jobs_channel", { jobs: [] })
    else
      queue = get_sidekiq_queue
      ActionCable.server.broadcast("jobs_channel", { jobs: queue })
    end
  end

  def perform(media_source_class, media_model, url, user)
    puts "Beginning to scrape #{url} @ #{Time.now}"
    media_item = media_source_class.extract(url)
    media_model.create_from_hash(media_item, user)
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
