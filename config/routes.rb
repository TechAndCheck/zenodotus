# typed: false
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root "login#index"
  root "archive#index"

  get "/archive/add", to: "archive#add"
  post "/archive/add", to: "archive#submit_url"

  post "/ingest/submit_mediareview", to: "ingest#submit_mediareview"

  resources :twitter_users, only: [:show]
  resources :instagram_users, only: [:show]
end
