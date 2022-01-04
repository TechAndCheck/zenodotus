class JobsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "jobs_channel"
  end

  def unsubscribed
  end
end
