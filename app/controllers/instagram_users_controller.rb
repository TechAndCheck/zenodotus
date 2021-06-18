class InstagramUsersController < ApplicationController
  def show
    @instagram_user = InstagramUser.find(params[:id])
    @archive_items = InstagramPost.where(author_id: @instagram_user.id)
  end
end
