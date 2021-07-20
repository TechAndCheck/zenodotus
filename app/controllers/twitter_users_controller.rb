# typed: ignore
class TwitterUsersController < ApplicationController
  def show
    @twitter_user = Sources::TwitterUser.find(params[:id])
    @archive_items = Sources::Tweet.where(author_id: @twitter_user.id).includes([:images, :videos])
  end
end
