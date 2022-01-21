# frozen_string_literal: true

# typed: strict

class AccountsController < ApplicationController
  before_action :authenticate_user!

  # A class representing the allowed params into the `change_password` endpoint
  class ChangePasswordParams < T::Struct
    const :password, String
    const :confirmed_password, String
  end

  class ChangeEmailParams < T::Struct
    const :email, String
  end

  sig { void }
  def index
    @pagy_text_searches, @text_searches = pagy(TextSearch.where(user: current_user).order("created_at DESC"), page_param: :text_search_page, items: 10)
    @pagy_image_searches, @image_searches = pagy(ImageSearch.where(user: current_user).order("created_at DESC"), page_param: :image_search_page, items: 7)
  end

  sig { void }
  def change_password
    typed_params = TypedParams[ChangePasswordParams].new.extract!(params)
    current_user.reset_password(typed_params.password, typed_params.confirmed_password)

    respond_to do |format|
      if typed_params.password != typed_params.confirmed_password
        flash.now[:alert] = "Passwords did not match. Please try again."
      else
        flash.now[:alert] = "Password updated."
      end
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes", locals: { flash: flash }),
      ] }
    end
  end

  sig { void }
  def change_email
    typed_params = TypedParams[ChangeEmailParams].new.extract!(params)
    current_user.email = typed_params.email
    current_user.save
    respond_to do |format|
      flash.now[:alert] = "Email updated."
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes", locals: { flash: flash }),
      ] }
    end
  end

  sig { void }
  def destroy
    user = User.find(params[:user])
    user.destroy
    redirect_to "/users/sign_in"
  end

  sig { void }
  def admin; end
end
