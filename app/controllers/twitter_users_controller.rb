# typed: strict

class TwitterUsersController < ApplicationController
  sig { void }
  def show
    @twitter_user = Sources::TwitterUser.find(params[:id])
    tweet_archive_items = ArchiveItem.includes(archivable_item: [:author, :images, :videos])
                                     .where(archivable_item_type: "Sources::Tweet")
    tweets_by_author = tweet_archive_items.select { |t| t.tweet.author == @twitter_user }
    @archive_items = tweets_by_author
  end

  # Exports all media items created by the currently viewed Twitter user to a JSON file
  sig { void }
  def export_tweeter_data
    tweet_archive_items = ArchiveItem.includes(archivable_item: [:author])
                                     .where(archivable_item_type: "Sources::Tweet")
    twitter_user = Sources::TwitterUser.find(params[:id])
    tweets_by_author = tweet_archive_items.select { |t| t.tweet.author == twitter_user }
    tweet_archive_json = ArchiveItem.prune_archive_items(tweets_by_author)
    send_data tweet_archive_json,
              type: "application/json; header=present",
              disposition: "attachment; filename=#{twitter_user.display_name.parameterize(separator: '_')}_twitter_archive.json"
  end
end
