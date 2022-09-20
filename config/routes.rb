# typed: false

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

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

  root "archive#index"

  scope "/apply" do
    get "/", to: "applicants#new", as: :new_applicant
    resources :applicants, path: "/", only: [:create]
    get "/confirm", to: "applicants#confirm", as: "applicant_confirm"
    get "/confirm/sent", to: "applicants#confirmation_sent", as: "applicant_confirmation_sent"
    get "/confirm/done", to: "applicants#confirmed", as: "applicant_confirmed"
  end

  get "/archive/add", to: "archive#add"
  post "/archive/add", to: "archive#submit_url"
  get "/archive/download", to: "archive#export_archive_data", as: "archive_download"
  post "/archive/scrape_result_callback", to: "archive#scrape_result_callback", as: "scrape_result_callback"

  post "/ingest/submit_media_review", to: "ingest#submit_media_review", as: "ingest_api_raw"
  post "/ingest/submit_media_review_source", to: "ingest#submit_media_review_source", as: "ingest_api_url"

  get "/image_search", to: "image_search#index", as: "image_search"
  post "/image_search", to: "image_search#search", as: "image_search_submit"

  get "/text_search", to: "text_search#index", as: "text_search"
  get "/text_search/search", to: "text_search#search", as: "text_search_submit"

  get "/account", to: "accounts#index", as: "account"
  post "/account/change_password", to: "accounts#change_password", as: "change_password"
  post "/account/change_email", to: "accounts#change_email", as: "change_email"
  delete "/account/users/", to: "accounts#destroy", as: "destroy_user"
  get "/account/setup/(:token)", to: "accounts#new", as: "new_account"
  post "/account/setup", to: "accounts#create", as: "create_account"

  get "/jobs", to: "jobs_status#index", as: "jobs_status_index"
  get "/jobs/scrapes", to: "jobs_status#scrapes", as: "jobs_status_scrapes"
  get "/jobs/active_jobs", to: "jobs_status#active_jobs", as: "jobs_status_active_jobs"
  delete "/jobs/:id", to: "jobs_status#delete_scrape", as: "job_status_delete"
  post "/jobs/resubmit/:id", to: "jobs_status#resubmit_scrape", as: "job_status_resubmit"

  resources :twitter_users, only: [:show]
  resources :instagram_users, only: [:show]
  resources :facebook_users, only: [:show]
  resources :youtube_channels, only: [:show]

  get "/facebook_users/:id/download", to: "facebook_users#export_facebook_user_data", as: "facebook_user_download"
  get "/instagram_users/:id/download", to: "instagram_users#export_instagram_user_data", as: "instagram_user_download"
  get "/twitter_users/:id/download", to: "twitter_users#export_tweeter_data", as: "twitter_user_download"
  get "/youtube_channels/:id/download", to: "youtube_channels#export_youtube_channel_data", as: "youtube_channel_download"
end
