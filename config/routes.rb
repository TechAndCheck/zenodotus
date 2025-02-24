# typed: false

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints host: Figaro.env.PUBLIC_LINK_HOST do
    # constraints(lambda { |request| request.host == Figaro.env.PUBLIC_LINK_HOST }) do
    scope module: "public_access", as: "public_access" do
      root "media#index"
      get "/media/:public_id", to: "media#show", as: "media"
      get "/:locale/media/:public_id", to: "media#show", as: "media_with_language"
      mount Shrine.download_endpoint => "/media/vault"
    end
  end

  # constraints(lambda { |request| [Figaro.env.FACT_CHECK_INSIGHTS_HOST, Figaro.env.MEDIA_VAULT_HOST].include?(request.host) }) do
  available_hosts = [Figaro.env.FACT_CHECK_INSIGHTS_HOST, Figaro.env.MEDIA_VAULT_HOST]
  available_hosts << "www.example.com" if Rails.env.test? # Rail's default host for tests is www.example.com

  constraints host: available_hosts do
    root "application#index"

    # This generates only the session and confirmation-related Devise URLs.
    devise_for :users,
              skip: :all,
              only: [
                :sessions,
                :confirmations,
                :registrations,
                :passwords
              ],
              controllers: {
                sessions: "users/sessions",
                confirmations: "users/confirmations",
            }

    scope "users/sign_in/mfa" do
      devise_scope :user do
        get "/", to: "users/sessions#mfa_validation", as: "mfa_validation"
        get "/webauthn", to: "users/sessions#begin_mfa_webauthn_validation", as: "begin_mfa_webauthn_validation"
        post "/webauthn", to: "users/sessions#finish_mfa_webauthn_validation", as: "finish_mfa_webauthn_validation"
        post "/totp", to: "users/sessions#finish_mfa_totp_validation", as: "finish_mfa_totp_validation"
        get "/webauthn/use_recovery_code", to: "users/sessions#mfa_use_recovery_code", as: "mfa_use_recovery_code"
        post "/webauthn/use_recovery_code", to: "users/sessions#mfa_validate_recovery_code", as: "mfa_validate_recovery_code"
      end
    end

    get "about", to: "application#about"
    get "contact", to: "application#contact"
    get "privacy", to: "application#privacy", as: "privacy"
    get "terms", to: "application#terms", as: "terms"
    get "select_locale/:locale", to: "application#select_locale", as: "select_locale"

    scope "/apply" do
      get "/", to: "applicants#new", as: "new_applicant"
      post "/", to: "applicants#create", as: "applicants"
      get "/confirm", to: "applicants#confirm", as: "applicant_confirm"
      get "/confirm/sent", to: "applicants#confirmation_sent", as: "applicant_confirmation_sent"
      get "/confirm/done", to: "applicants#confirmed", as: "applicant_confirmed"
    end

    namespace "admin" do
      root action: "dashboard"

      namespace "jobs_status" do
        root action: "index"
        get "scrapes"
        get "active_jobs"
        post "clear_all_jobs", as: "clear_all_jobs"
        post "resubmit_all_unfulfilled_scrape", as: "resubmit_all_unfulfilled_scrape"
        delete ":id", action: "delete_scrape", as: "delete"
        post "resubmit/:id", action: "resubmit_scrape", as: "resubmit"
      end

      resources :applicants, only: [:index, :show]
      post "applicants/:id/approve", to: "applicants#approve", as: "applicant_approve"
      post "applicants/:id/reject", to: "applicants#reject", as: "applicant_reject"
      post "applicants/:id/update", to: "applicants#update", as: "applicant_update"
      delete "applicants/:id", to: "applicants#delete", as: "applicant_delete"

      # post "web_scrapes/scrape_selected", action: "web_scrapes#scrape_selected", as: "scrape_selected"

      resources :web_scrapes, only: [:index, :new, :create, :destroy] do
        post :handle_form, on: :collection
        post "scrape", action: "scrape_now", as: "scrape"
      end

      resources :fact_check_organizations, only: [:index]
      resources :users, only: [:index, :show] do
        post "reset_mfa", action: "reset_mfa", as: "reset_mfa"
      end
    end
  end

  available_hosts = [Figaro.env.FACT_CHECK_INSIGHTS_HOST]
  available_hosts << "www.example.com" if Rails.env.test? # Rail's default host for tests is www.example.com
  constraints host: available_hosts do
    scope module: "fact_check_insights", as: "fact_check_insights" do
      root "application#index"
      get "download"
      get "guide"
      get "highlights"
      get "optout"
    end
  end

  available_hosts = [Figaro.env.MEDIA_VAULT_HOST]
  available_hosts << "www.example.com" if Rails.env.test? # Rail's default host for tests is www.example.com
  constraints host: available_hosts do
    scope module: "media_vault", as: "media_vault" do
      root "application#index"

      get "dashboard", to: "archive#index"
      get "myvault", to: "archive#index", defaults: { myvault: true }
      get "guide"
      get "optout"

      get "status", to: "archive#status"
      get "status/:scrape_id/restart", to: "archive#restart_scrape", as: "restart_scrape"

      get "search", to: "search#index", as: "search"
      post "search_by_media", to: "search#search_by_media", as: "search_by_media"
      get "search_image/:google_image_id", to: "search#google_image_link", as: "google_image_link"

      get "authors/:platform/:id", to: "authors#show", as: "author"
      resources :media, only: [:show, :destroy]

      get "media/download_metadata/:id", to: "media#export_metadata", as: "export_media_metadata"
    end
  end

  # These routes shouldn't be nested in the `host` constraints block above,
  # but should still be scoped by `media_vault` module.
  scope module: "media_vault", as: "media_vault" do
    scope "ingest", as: "ingest" do
      post "submit_review", to: "ingest#submit_review", as: "api_raw"
      post "submit_media_review_source", to: "ingest#submit_media_review_source", as: "api_url"
    end

    scope "archive", as: "archive" do
      get "add", to: "archive#add"
      post "add", to: "archive#submit_url"
      get "download", to: "archive#export_archive_data", as: "download"
      post "scrape_result_callback", to: "archive#scrape_result_callback", as: "scrape_result_callback"
    end

    scope "api", format: :json do
      get "/check_if_logged_in", to: "api#check_if_logged_in", as: "api_check_if_logged_in"
      post "/submit", to: "api#submit", as: "api_submit"
    end
  end

  scope "/account" do
    get "/", to: "accounts#index", as: "account"
    post "/change_password", to: "accounts#change_password", as: "change_password"
    post "/change_email", to: "accounts#change_email", as: "change_email"
    post "/destroy_account", to: "accounts#destroy_account", as: "destroy_account"
    get "/setup/(:token)", to: "accounts#new", as: "new_account"
    post "/setup", to: "accounts#create", as: "create_account"
    get "/remote_token", to: "accounts#remote_token", as: "remote_token"

    scope "/mfa" do
      delete "/totp", to: "accounts#destroy_totp_device", as: "destroy_totp_device"
      delete "/:device_id", to: "accounts#destroy_mfa_device", as: "destroy_mfa_device"
    end
  end

  scope "setup_mfa" do
    get "/", to: "accounts#setup_mfa", as: "account_setup_mfa"
    get "/webauthn", to: "accounts#start_webauthn_setup", as: "account_start_webauthn_setup"
    post "/webauthn", to: "accounts#finish_webauthn_setup", as: "account_finish_webauthn_setup"
    get "/webauthn/setup_recovery_codes", to: "accounts#setup_recovery_codes", as: "account_setup_recovery_codes"
    get "/totp", to: "accounts#start_totp_setup", as: "account_start_totp_setup"
    post "/totp", to: "accounts#finish_totp_setup", as: "account_finish_totp_setup"
  end

  get "/account/reset_password", to: "accounts#reset_password", as: "reset_password"
  post "/account/reset_password", to: "accounts#send_password_reset_email", as: "send_password_reset_email"
end
