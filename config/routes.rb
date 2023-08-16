Rails.application.routes.draw do
  root to: "estimates#index"

  resources :estimates, only: [:index]
end
