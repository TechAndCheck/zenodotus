class ScrapesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "scrapes_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
