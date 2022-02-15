class JobsChannel < ApplicationCable::Channel
  # An ActionCable channel used to update the jobs status page
  def subscribed
    stream_from "jobs_channel"
  end

  def unsubscribed
  end
end
