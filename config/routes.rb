Rails.application.routes.draw do
  scope constraints: { format: :json }, defaults: { format: :json } do
    resources :projects
    post "/sense" => "sense#create"
  end

  devise_for :users

  root "home#index"
end
