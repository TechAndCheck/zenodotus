# typed: strict
class JobsStatusController < ApplicationController
  require "sidekiq/api"

  # Index function. Makes available an instance variable containing jobs queue details
  sig { void }
  def index
    @jobs_queue = []
    return if Sidekiq::Queue.new.size.zero?

    @jobs_queue = Sidekiq::Queue.new.to_a.reverse.each_with_index.map do |job, ind|
      {
        queue_position: ind + 1,
        url: job.item["args"][0]["arguments"].last,
        enqueued_at: Time.at(job.item["enqueued_at"])
      }
    end
  end
end
