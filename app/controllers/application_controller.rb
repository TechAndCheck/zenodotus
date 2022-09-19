# typed: strict

class ApplicationController < ActionController::Base
  extend T::Sig
  extend T::Helpers
  include Pagy::Backend

  protect_from_forgery with: :null_session, if: :json_request?, prepend: true

protected

  sig { returns(T::Boolean) }
  def json_request?
    request.format.json?
  end

  sig { void }
  def must_be_logged_out
    unless current_user.nil?
      respond_to do |format|
        format.html do
          flash[:error] = "You cannot access that resource while logged in. Please log out and try again."
          redirect_to after_sign_in_path_for(current_user)
        end
        format.turbo_stream do
          flash.now[:error] = "You cannot access that resource while logged in. Please log out and try again."
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
          ]
        end
        format.json do
          render json: {
            error: "Resource not available while authenticated."
          }, status: :unauthorized
        end
      end
    end
  end

  sig { void }
  def authenticate_user_from_api_key!
    if params[:api_key].blank?
      render json: {
        error: "Unauthorized credentials, please check your API Key"
      }, status: :unauthorized
      return false
    end

    api_key = params[:api_key].presence
    hashed_api_key = ZenoEncryption.hash_string(api_key)
    api_key = hashed_api_key && ApiKey.find_by_hashed_api_key(hashed_api_key)

    # Devise.secure_compare prevents timing attacks
    if api_key && Devise.secure_compare(api_key.hashed_api_key, hashed_api_key)
      api_key.update_with_use(request)
      sign_in(api_key.user, store: false)
    else
      render json: {
        error: "Unauthorized credentials, please check your API Key"
      }, status: :unauthorized
      return false
    end
    true
  end

  # Routes users to the sign in page after they've logged out
  # Overrides the Devise default method, which re-routes users to the root page
  sig { params(user: Symbol).returns(String) }
  def after_sign_out_path_for(user)
    new_user_session_path
  end

  sig { returns(T::Boolean) }
  def authenticate_super_user
    # First we make sure they're logged in at all, this also sets the current user so we can check it
    return false unless authenticate_user!

    current_user.super_admin?
  end

  sig { void }
  def authenticate_super_user!
    # First we make sure they're logged in at all, this also sets the current user so we can check it
    authenticate_user!

    unless current_user.super_admin?
      redirect_back_or_to "/", allow_other_host: false, alert: "You must be a super user/admin to access this page."
    end
  end
end
