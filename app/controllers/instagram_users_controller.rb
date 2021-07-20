class InstagramUsersController < ApplicationController
  def show
    @instagram_user = Sources::InstagramUser.find(params[:id])
    @archive_items = Sources::InstagramPost.where(author_id: @instagram_user.id).includes([:images, :videos])
  end
end
