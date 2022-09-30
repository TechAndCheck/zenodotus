# typed: strict

class ApplicationController < ActionController::Base
  extend T::Sig
  extend T::Helpers
  include Pagy::Backend

  protect_from_forgery with: :null_session, if: :json_request?, prepend: true

  before_action :set_site_variables_from_subdomain

  sig { void }
  def index
    (render("media_vault/index") && return) if site_is_media_vault?

    render "fact_check_insights/index"
  end

  sig { params(user: User).returns(String) }
  def after_sign_in_path_for(user)
    return media_vault_archive_root_path if site_is_media_vault?

    root_path
  end

  sig { returns(T::Boolean) }
  def site_is_fact_check_insights?
    get_site_from_subdomain == "fact_check_insights"
  end

  sig { returns(T::Boolean) }
  def site_is_media_vault?
    get_site_from_subdomain == "media_vault"
  end

protected

  # Given a domain hostname, returns an array with each segment in reverse order: TLD first, then
  # primary domain, then subdomains. E.g., `"www.example.com"` → `["com","example","www"]`.
  # Explicitly expects to operate on only the hostname, not the protocol, ports, path, etc.
  sig { params(hostname: String).returns(Array) }
  def hostname_segments(hostname)
    hostname.split(".").reverse
  end

  # Returns which site is currently being requested based on subdomain.
  # A little over-engineered, but prepared for future apps and for a different fallback default.
  # But currently, falls back to Insights.
  sig { returns(String) }
  def get_site_from_subdomain
    segments = hostname_segments(request.host)

    # Bail out entirely and move on to the fallback if we aren't on a recognized domain pattern.
    if segments[1] == "factcheckinsights"
      case segments[2]
      when "vault"
        return "media_vault"
      # Even though Insights is the default, let's keep it in the list in case that changes.
      when "www"
        return "fact_check_insights"
      end
    end

    "fact_check_insights"
  end

  sig { void }
  def set_site_variables_from_subdomain
    @site = get_site_from_subdomain

    case @site
    when "media_vault"
      @site_title = "MediaVault"
      return
    # Even though Insights is the default, let's keep it in the list in case that changes.
    when "fact_check_insights"
      @site_title = "Fact-Check Insights"
      return
    end

    @site_title = "Fact-Check Insights"
  end

  sig { returns(T::Boolean) }
  def json_request?
    request.format.json?
  end

  sig { void }
  def must_be_logged_out
    unless current_user.nil?
      respond_to do |format|
        format.html do
          redirect_back_or_to after_sign_in_path_for(current_user), allow_other_host: false, flash: { error: "You cannot access that resource while logged in. Please log out and try again." }
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

  sig { returns(T::Boolean) }
  def authenticate_super_user
    # First we make sure they're logged in at all, this also sets the current user so we can check it
    return false unless authenticate_user!

    current_user.is_admin?
  end

  sig { void }
  def authenticate_super_user!
    # First we make sure they're logged in at all, this also sets the current user so we can check it
    authenticate_user!

    unless current_user.is_admin?
      redirect_back_or_to "/", allow_other_host: false, alert: "You don’t have permission to access that page."
    end
  end
end
