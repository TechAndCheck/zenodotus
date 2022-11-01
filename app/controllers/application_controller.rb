# typed: strict

class ApplicationController < ActionController::Base
  extend T::Sig
  extend T::Helpers
  include Pagy::Backend

  protect_from_forgery with: :null_session, if: :json_request?, prepend: true

  before_action :set_site_from_host

  sig { void }
  def index
    if site_is_fact_check_insights?
      # This is obviously just pretend for now.
      claim_review_count = ClaimReview.count
      organization_count = 204
      country_count = 71
      @stats = {
        fact_checks: claim_review_count,
        organizations: organization_count,
        countries: country_count,
      }
    end

    render "#{@site[:shortname]}/index"
  end

  sig { void }
  def about; end

  sig { void }
  def contact; end

  sig { params(user: User).returns(String) }
  def after_sign_in_path_for(user)
    if site_is_media_vault?
      return media_vault_dashboard_path if user.can_access_media_vault?

      # TODO: Lead to the Media Vault "Request Access For Existing Insights User" page (#382)
      return media_vault_root_path
    end

    root_path
  end

  sig { returns(T::Boolean) }
  def site_is_fact_check_insights?
    get_site_from_host == SiteDefinitions::FACT_CHECK_INSIGHTS
  end

  sig { returns(T::Boolean) }
  def site_is_media_vault?
    get_site_from_host == SiteDefinitions::MEDIA_VAULT
  end

protected

  # Returns which site is currently being requested based on host.
  # A little over-engineered, but prepared for future apps and for a different fallback default.
  # Currently falls back to Insights.
  sig { returns(Hash) }
  def get_site_from_host
    site = SiteDefinitions::BY_HOST[request.host]
    return site if site.present?

    # Fall back to Insights
    SiteDefinitions::FACT_CHECK_INSIGHTS
  end

  sig { void }
  def set_site_from_host
    @site = get_site_from_host
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
