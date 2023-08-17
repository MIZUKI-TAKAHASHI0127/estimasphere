Rails.application.routes.draw do
  
  root to: "estimates#index"
  devise_for :users

  resources :estimates, only: [:index]
end
