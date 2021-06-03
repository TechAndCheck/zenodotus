class TwitterUsersController < ApplicationController
  def show
    @twitter_user = TwitterUser.find(params[:id])
    @archive_items = Tweet.where(author_id: @twitter_user.id)
  end
end
