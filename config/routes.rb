# typed: false
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root "login#index"
  root "archive#index"

  get "/archive/add", to: "archive#add"
  post "/archive/add", to: "archive#submit_url"

  get "/image_search", to: "image_search#index", as: "image_search"
  post "/image_search", to: "image_search#search", as: "image_search_submit"

  get "/text_search", to: "text_search#index", as: "text_search"
  post "/text_search", to: "text_search#search", as: "text_search_submit"

  get "/archive/search", to: "archive#search"

  resources :twitter_users, only: [:show]
  resources :instagram_users, only: [:show]
end
