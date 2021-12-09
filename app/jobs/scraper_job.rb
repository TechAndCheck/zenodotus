class ScraperJob < ApplicationJob
  require "sidekiq/api"

  queue_as :default


  after_enqueue do |job|
    unless Sidekiq::Queue.new.size.zero?
      queue = Sidekiq::Queue.new.map do |job|
        {
          task: "scrape",
          url: job.item["args"][0]["arguments"].last
        }
      end

      puts "----queue------"
      puts queue
      ActionCable.server.broadcast("jobs_channel", { jobs: queue })
      # Send queue to ActionCable
    end
  end

  after_perform do |job|
    if Sidekiq::Queue.new.size.zero?
      ActionCable.server.broadcast("jobs_channel", { jobs: [] })
    else
      queue = Sidekiq::Queue.new.map do |job|
        {
          task: "scrape",
          url: JSON.parse(job.value)["args"]["arguments"].last
        }
      end
      ActionCable.server.broadcast("jobs_channel", { jobs: queue })
    end
  end

  def perform(media_source_class, media_model, url)
    media_item = media_source_class.extract(url)
    media_model.create_from_hash(media_item)
  end
end
