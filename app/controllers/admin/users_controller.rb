class Admin::UsersController < ApplicationController
  USERS_PER_PAGE = 50

  def index
    @users = User.all
    @pagy_items, @users = pagy_array(
      @users,
      page_param: :p,
      items: USERS_PER_PAGE
    )
  end

  def show
    @user = User.find(params[:id])
  end

  def reset_mfa
    @user = User.find(params[:user_id])
    @user.reset_mfa!
    redirect_to admin_user_path(@user), notice: "MFA reset for user."
  end
end
