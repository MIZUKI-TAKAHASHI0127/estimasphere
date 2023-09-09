Rails.application.routes.draw do
  devise_for :users
  
  root to: "estimates#index"
  
  resources :estimates, only: [:index] do
    collection do
      get :data_registration
    end
  end
  get 'sales_quotations/search_customer', to: 'sales_quotations#search_customer'

  resources :representatives, only: [:index] do
    get 'update_representatives', on: :collection
  end
  
  resources :company_infos, only: [:new, :create, :index, :show, :edit, :update]
  
  resources :customers, only: [:new, :create, :index, :show, :edit, :update] do
    
    collection do
      get :find
    end
    member do
      get 'new_representative', to: 'customers#new_representative'
      post 'new_representative', to: 'customers#create_representative'
      get :representatives
    end
  end  
  
  resources :sales_quotations, only: [:new, :create, :index, :show, :edit, :update] do
    collection do
      get :search_customer
      get :new_item
      get :representative_options
    end
    member do
      get :preview
    end
  end
  
  resources :categories, only: [:new, :create, :index]
  
  resources :units, only: [:new, :create, :index]

  get '/estimates/data_registration', to: 'estimates#data_registration', as: :data_registration
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end