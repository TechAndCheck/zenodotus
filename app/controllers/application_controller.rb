# typed: strict
class ApplicationController < ActionController::Base
  extend T::Sig
  extend T::Helpers

  protect_from_forgery with: :null_session, if: :json_request?, prepend: true

protected

  sig { void }
  def json_request?
    request.format.json?
  end

  sig { void }
  def authenticate_user_from_api_key!
    api_key = params[:api_key].presence
    hashed_api_key = Digest::SHA256.hexdigest(api_key)
    api_key = hashed_api_key && ApiKey.find_by_hashed_api_key(hashed_api_key)

    # Devise.secure_compare prevents timing attacks
    if api_key && Devise.secure_compare(api_key.hashed_api_key, hashed_api_key)
      sign_in(api_key.user, store: false)
    else
      render json: {
        error: "Unauthorized credentials, please check your API Key"
      }, status: :unauthorized
      return false
    end
    true
  end
end
