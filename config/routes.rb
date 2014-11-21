Rails.application.routes.draw do
  get '/dashboard' => "dashboard#index", as: :dashboard

  devise_for :users

  root "home#index"
end
