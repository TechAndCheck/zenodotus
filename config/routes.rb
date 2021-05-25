# typed: false
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root "login#index"
  root "media#index"

  get "/media/add", to: "media#add"
  post "/media/add", to: "media#submit_url"
end
