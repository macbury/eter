Rails.application.routes.draw do
  namespace :api, constraints: { format: :json }, defaults: { format: :json } do
    resources :projects
    get "/angular" => "angular#show"
    post "/sense" => "sense#create", as: :sense
    get "/members" => "members#show"
  end

  devise_for :users

  root "home#index"
end
