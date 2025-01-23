# typed: strict

class ApplicationController < ActionController::Base
  extend T::Sig
  extend T::Helpers
  include Pagy::Backend

  protect_from_forgery with: :null_session, if: :json_request?, prepend: true

  before_action :set_site_from_host
  around_action :switch_locale

  sig { void }
  def index
    if site_is_fact_check_insights?
      claim_review_count = ClaimReview.count
      organization_count = FactCheckOrganization.where("(SELECT COUNT(*) FROM claim_reviews WHERE claim_reviews.claim_review_author_id = fact_check_organizations.id) > 0").count

      # This following number has to be manually updated since there's no data anywhere that
      # represents the country of the fact checker.
      country_count = 71
      @stats = {
        fact_checks: claim_review_count,
        organizations: organization_count,
        countries: country_count,
      }
      @page_metadata = { title: "Home", description: "Fact Check Insights Home" }
    else
      @page_metadata = { title: "Home", description: "Media Vault Home" }
    end

    render "#{@site[:shortname]}/index"
  end

  sig { void }
  def about; end

  sig { void }
  def contact; end

  sig { void }
  def privacy; end

  sig { void }
  def terms; end

  sig { void }
  def select_locale
    user.update!(locale: params[:locale]) if current_user
    redirect_to("#{params[:current_path]}?locale=#{params[:locale]}",
                    fallback_location: root_path(locale: params[:locale])) && return
  end

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
  def must_have_mfa_setup
    return if current_user.nil? || current_user.mfa_enabled?
    redirect_to account_setup_mfa_path, allow_other_host: false, flash: { error: "You must setup two-factor authentication before continuing." }
  end

  # We require users to have MFA enabled, so this stops them from accessing the site unless they do
  sig { void }
  def authenticate_user_and_setup!
    return false unless authenticate_user!
    must_have_mfa_setup
  end

  # TODO: Implement the following before landing, the debugger is there to remind you
  sig { void }
  def authenticate_and_require_mfa!
    # Make sure a user is logged in, then redirect them to the MFA page to authenticate before moving on
    # We'll have to remember which page they were trying to get to, the full request, basically intercept
    # it and replay it after validation.

    authenticate_user_and_setup! # run normal validation first

    # Probably see if we can save/store a request? IDK this is going to get complicated. Maybe we just
    # keep it for logging in only?
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

  sig { void }
  def authenticate_user_from_remote_key!
    remote_key = params["auth_key"]
    if remote_key.blank?
      render json: {
        error: "Unauthorized credentials, please check your Remote Key"
      }, status: :unauthorized
      return false
    end

    user_remote_key = UserRemoteKey.find_by_remote_key(remote_key)

    if !user_remote_key || user_remote_key.expired?
      render json: {
        error: "Unauthorized credentials, please check your Remote Key"
      }, status: :unauthorized
      return false
    elsif user_remote_key.key_valid?
      user_remote_key.update_with_use(request)
      sign_in(user_remote_key.user, store: false)
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
    authenticate_user_and_setup!

    unless current_user.is_admin?
      redirect_back_or_to "/", allow_other_host: false, flash: { error: "You don’t have permission to access that page." }
    end
  end

  sig { void }
  def check_for_login_and_remote_token
    return true unless params["token"] == "true" || session[:token] == true

    if current_user
      redirect_to(remote_token_path) && return
    end

    true
  end

  sig { returns(String) }
  def render_unauthorized
    render file: "#{Rails.root}/public/401.html",
      layout: false,
      content_type: "text/html",
      status: :unauthorized
  end

  sig { params(origin: String).returns(WebAuthn::RelyingParty) }
  def relying_party(origin)
    uri = URI(origin)

    allowed_hosts = [ Figaro.env.FACT_CHECK_INSIGHTS_HOST,
                      Figaro.env.MEDIA_VAULT_HOST,
                      Figaro.env.PUBLIC_LINK_HOST ]

    unless allowed_hosts.include?(uri.host)
      raise "Invalid origin host #{uri.scheme}://#{uri.host}"
    end

    WebAuthn::RelyingParty.new(
      id: Figaro.env.AUTH_BASE_HOST, # This lets us use the same creds for subdomains
      origin: "#{uri.scheme}://#{uri.host}", # Make sure that the url is the url we're on
      name: "FactCheck Insights/MediaVault"
    )
  end

  # sig { void }
  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    locale = current_user.locale if current_user && !current_user.locale.blank?

    I18n.with_locale(locale, &action)
  end
end
