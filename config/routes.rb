# typed: false
Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root "login#index"
  root "archive#index"

  get "/archive/add", to: "archive#add"
  post "/archive/add", to: "archive#submit_url"

  post "/ingest/submit_media_review", to: "ingest#submit_media_review", as: "ingest_api"

  get "/image_search", to: "image_search#index", as: "image_search"
  post "/image_search", to: "image_search#search", as: "image_search_submit"

  resources :twitter_users, only: [:show]
  resources :instagram_users, only: [:show]
end
