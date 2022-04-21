class YoutubeChannelsController < ApplicationController
  sig { void }
  def show
    @youtube_channel = Sources::YoutubeChannel.find(params[:id])
    @archive_items = Sources::YoutubePost.where(channel_id: @youtube_channel.id).includes([:videos])
  end
end
