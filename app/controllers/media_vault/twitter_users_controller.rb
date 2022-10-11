# typed: strict

class MediaVault::TwitterUsersController < MediaVaultController
  sig { void }
  def show
    @twitter_user = Sources::TwitterUser.find(params[:id])
    tweet_archive_items = ArchiveItem.includes(archivable_item: [:author, :images, :videos])
                                     .where(archivable_item_type: "Sources::Tweet")
    tweets_by_author = tweet_archive_items.select { |t| t.tweet.author == @twitter_user }

    respond_to do |format|
      format.html { @archive_items = tweets_by_author }
      format.json do
        send_data ArchiveItem.generate_pruned_json(tweets_by_author),
          type: "application/json",
          filename: "#{@twitter_user.display_name.parameterize(separator: '_')}_twitter_archive.json"
      end
    end
  end
end
