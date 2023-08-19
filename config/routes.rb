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

  resources :customers, only: [:new, :create, :index, :show, :edit, :update] do
    collection do
      get :find
      get :representatives
    end
    member do
      get 'new_representative', to: 'customers#new_representative'
      post 'new_representative', to: 'customers#create_representative'
    end
  end
end

