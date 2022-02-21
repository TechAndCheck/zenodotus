# typed: false
Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: "users/sessions"
             }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root "login#index"
  root "archive#index"

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
  post "/settings/approve", to: "settings#approveUserRequest", as: "approve_request"
  post "/settings/deny", to: "settings#denyUserRequest", as: "deny_request"

  get "/jobs", to: "jobs_status#index", as: "jobs_status"

  resources :twitter_users, only: [:show]
  resources :instagram_users, only: [:show]
  resources :facebook_users, only: [:show]
  resources :organizations, only: [:index]

  put "/organizations/:organization_id/update_admin/:user_id", to: "organizations#update_admin", as: "organization_update_admin"
  delete "/organizations/:organization_id/update_admin/:user_id", to: "organizations#delete_user", as: "organization_delete_user"

  get "/instagram_users/:id/download", to: "instagram_users#export_instagram_user_data", as: "instagram_user_download"
  get "/twitter_users/:id/download", to: "twitter_users#export_tweeter_data", as: "twitter_user_download"
end
