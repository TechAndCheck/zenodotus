class JobsStatusController < ApplicationController
  require "sidekiq/api"

  def index
    @jobs_queue = []
    unless Sidekiq::Queue.new.size.zero?
      @jobs_queue = Sidekiq::Queue.new.to_a.reverse.each_with_index.map do |job, ind|
        {
          queue_position: ind + 1,
          url: job.item["args"][0]["arguments"].last,
          enqueued_at: Time.at(job.item["enqueued_at"]),
        }
      end
    end
  end
end
