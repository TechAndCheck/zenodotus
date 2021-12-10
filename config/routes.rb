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

  post "/ingest/submit_media_review", to: "ingest#submit_media_review", as: "ingest_api_raw"
  post "/ingest/submit_media_review_source", to: "ingest#submit_media_review_source", as: "ingest_api_url"

  get "/image_search", to: "image_search#index", as: "image_search"
  post "/image_search", to: "image_search#search", as: "image_search_submit"

  get "/text_search", to: "text_search#index", as: "text_search"
  get "/text_search/search", to: "text_search#search", as: "text_search_submit"

  get "/settings", to: "settings#index", as: "settings"
  post "/settings/approve", to: "settings#approveUserRequest", as: "approve_request"
  post "/settings/deny", to: "settings#denyUserRequest", as: "deny_request"

  get "/jobs", to: "jobs_status#index", as: "jobs_status"

  resources :twitter_users, only: [:show]
  resources :instagram_users, only: [:show]
end
