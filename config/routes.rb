Rails.application.routes.draw do
  
  root to: "estimates#index"
  devise_for :users

  resources :estimates, only: [:index] do
    collection do
      get :data_registration
    end
  end

  resources :company_infos, only: [:new, :create, :index, :show, :edit, :update]

  resources :categories, only: [:new, :create, :index]

  resources :units, only: [:new, :create, :index]
end
