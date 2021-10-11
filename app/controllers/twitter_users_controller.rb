# typed: ignore
class TwitterUsersController < ApplicationController
  def show
    @twitter_user = Sources::TwitterUser.find(params[:id])
    @archive_items = Sources::Tweet.where(author_id: @twitter_user.id).includes([:images, :videos])
  end

  def export_tweeter_data
    twitter_user = Sources::TwitterUser.find(params[:id])
    tweet_archive_items = ArchiveItem.includes(archivable_item: [:author])
                                     .where(archivable_item_type: "Sources::Tweet")
    tweets_by_author = tweet_archive_items.select { |t| t.tweet.author == twitter_user }
    tweet_archive_json = helpers.prune_archive_items(tweets_by_author)
    send_data tweet_archive_json,
              type: "application/json; header=present",
              disposition: "attachment; filename=#{twitter_user.display_name.parameterize(separator: '_')}_archive.json"
  end
end
