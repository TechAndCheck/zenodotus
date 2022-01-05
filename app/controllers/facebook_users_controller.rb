class FacebookUsersController < ApplicationController
  def show
    @facebook_user = Sources::FacebookUser.find(params[:id])
    @archive_items = Sources::FacebookPost.where(author_id: @facebook_user.id).includes([:images, :videos])
  end
end
