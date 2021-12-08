class JobsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "jobs_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
