# typed: false

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "application#index"

  # This generates only the session and confirmation-related Devise URLs.
  devise_for :users,
             skip: :all,
             only: [
               :sessions,
               :confirmations,
             ],
             controllers: {
               sessions: "users/sessions",
               confirmations: "users/confirmations",
             }

  get "about", to: "application#about"
  get "contact", to: "application#contact"

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
      delete ":id", action: "delete_scrape", as: "delete"
      post "resubmit/:id", action: "resubmit_scrape", as: "resubmit"
    end

    resources :applicants, only: [:index, :show]
    post "applicants/:id/approve", to: "applicants#approve", as: "applicant_approve"
    post "applicants/:id/reject", to: "applicants#reject", as: "applicant_reject"
  end

  constraints host: Figaro.env.FACT_CHECK_INSIGHTS_HOST do
    scope module: "fact_check_insights", as: "fact_check_insights" do
      root "application#index"

      get "download"
      get "guide"
      get "highlights"
      get "terms"
      get "privacy"
      get "optout"
    end
  end

  constraints host: Figaro.env.MEDIA_VAULT_HOST do
    scope module: "media_vault", as: "media_vault" do
      root "application#index"

      get "dashboard", to: "archive#index"
      get "guide"
      get "terms"
      get "privacy"
      get "optout"

      get "/image_search", to: "image_search#index", as: "image_search"
      post "/image_search", to: "image_search#search", as: "image_search_submit"

      get "/text_search", to: "text_search#index", as: "text_search"
      get "/text_search/search", to: "text_search#search", as: "text_search_submit"

      resources :twitter_users, only: [:show]
      resources :instagram_users, only: [:show]
      resources :facebook_users, only: [:show]
      resources :youtube_channels, only: [:show]
    end
  end

  # These routes shouldn't be nested in the `host` constraints block above,
  # but should still be scoped by `media_vault` module.
  scope module: "media_vault", as: "media_vault" do
    scope "ingest", as: "ingest" do
      post "submit_media_review", to: "ingest#submit_media_review", as: "api_raw"
      post "submit_media_review_source", to: "ingest#submit_media_review_source", as: "api_url"
    end

    scope "archive", as: "archive" do
      get "add", to: "archive#add"
      post "add", to: "archive#submit_url"
      get "download", to: "archive#export_archive_data", as: "download"
      post "scrape_result_callback", to: "archive#scrape_result_callback", as: "scrape_result_callback"
    end
  end

  get "/account", to: "accounts#index", as: "account"
  post "/account/change_password", to: "accounts#change_password", as: "change_password"
  post "/account/change_email", to: "accounts#change_email", as: "change_email"
  delete "/account/users/", to: "accounts#destroy", as: "destroy_user"
  get "/account/setup/(:token)", to: "accounts#new", as: "new_account"
  post "/account/setup", to: "accounts#create", as: "create_account"
end
