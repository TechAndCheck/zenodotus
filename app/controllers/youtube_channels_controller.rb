# typed: strict

class YoutubeChannelsController < ApplicationController
  before_action :authenticate_user!

  sig { void }
  def show
    @youtube_channel = Sources::YoutubeChannel.find(params[:id])
    youtube_post_archive_items = ArchiveItem.includes(archivable_item: [:author, :images, :videos])
                                            .where(archivable_item_type: "Sources::YoutubePost")
    youtube_posts_by_channel = youtube_post_archive_items.select { |t| t.youtube_post.author == @youtube_channel }
    @archive_items = youtube_posts_by_channel
  end

  # Exports all media items created by the currently viewed YouTube channel to a JSON file
  sig { void }
  def export_youtube_channel_data
    youtube_post_archive_items = ArchiveItem.includes(archivable_item: [:author])
                                            .where(archivable_item_type: "Sources::YoutubePost")
    youtube_channel = Sources::YoutubeChannel.find(params[:id])
    youtube_posts_by_channel = youtube_post_archive_items.select { |t| t.youtube_post.author == youtube_channel }
    youtube_post_archive_json = ArchiveItem.prune_archive_items(youtube_posts_by_channel)
    send_data youtube_post_archive_json,
              type: "application/json; header=present",
              disposition: "attachment; filename=#{youtube_channel.title.parameterize(separator: '_')}_youtube_archive.json"
  end
end
