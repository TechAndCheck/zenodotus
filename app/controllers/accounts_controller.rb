# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @text_searches = pagy(TextSearch.where(user_id: current_user.id).order("created_at DESC"), page_param: :text_search_page, items: 10)
    @pagy_, @image_searches = pagy(ImageSearch.where(submitter_id: current_user.id).order("created_at DESC"), page_param: :image_search_page, items: 7)
  end

  # A class representing the allowed params into the `change_password` endpoint
  class ChangePasswordParams < T::Struct
    const :password, String
    const :confirmed_password, String
  end

  class ChangeEmailParams < T::Struct
    const :email, String
  end

  def change_password
    typed_params = TypedParams[ChangePasswordParams].new.extract!(params)
    current_user.reset_password(typed_params.password, typed_params.confirmed_password)
  end

  def change_email
    typed_params = TypedParams[ChangeEmailParams].new.extract!(params)
    current_user.email = typed_params.email
    current_user.save
  end

  def approveUserRequest
    user = User.find(params[:user])
    user.update(approved: true)
  end

  def denyUserRequest
    user = User.find(params[:user])
    user.destroy
  end

  def destroy
    user = User.find(params[:user])
    user.destroy
    redirect_to "/users/sign_in"
  end

  def admin; end
end
