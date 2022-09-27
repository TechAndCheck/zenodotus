# typed: strict

class MediaVault::YoutubeChannelsController < MediaVaultController
  sig { void }
  def show
    @youtube_channel = Sources::YoutubeChannel.find(params[:id])
    youtube_post_archive_items = ArchiveItem.includes(archivable_item: [:author, :images, :videos])
                                            .where(archivable_item_type: "Sources::YoutubePost")
    youtube_posts_by_channel = youtube_post_archive_items.select { |t| t.youtube_post.author == @youtube_channel }

    respond_to do |format|
      format.html { @archive_items = youtube_posts_by_channel }
      format.json do
        send_data ArchiveItem.generate_pruned_json(youtube_posts_by_channel),
          type: "application/json",
          filename: "#{@youtube_channel.title.parameterize(separator: '_')}_youtube_archive.json"
      end
    end
  end
end
