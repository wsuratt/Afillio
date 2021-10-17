Rails.application.routes.draw do
  resources :reviews
  
  resources :support do
    get :sign_up, on: :collection
    get :withdraw_balance, on: :collection
    get :sell_product, on: :collection
  end
  
  devise_for :users, :controllers => { registrations: 'users/registrations', confirmations: 'users/confirmations' }
  resources :users, only: [:index, :edit, :show, :update] do
    get :verify_vendors, on: :collection
    member do
      get :become_vendor
      get :vendor_info
      patch :vendor_info_update
      put :vendor_info_update
    end
  end
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user

  resources :products do
    get :purchased, :created, on: :collection
  end
  
  resources :orders, path_names: { edit: ':id/edit', new: 'new/:title/:referral_token' } do
    get :my_orders, on: :collection
    get :my_sales, on: :collection
    member do
      get :tracking_number
      patch :tracking_number_update
      put :tracking_number_update
    end
  end
  post 'orders/new/:title/:referral_token', to: 'orders#create'
  
  post 'checkout/create', to: 'checkout#create'
  get 'checkout/success', to: 'checkout#success'
  resources :webhooks, only: [:create]
  
  get 'stripe/connect', to: 'stripe#connect', as: :stripe_connect
  get 'payout/transfer', to: 'payout#transfer'
  
  root 'home#index'
  get 'how-it-works', to: 'home#how_it_works'
  get 'privacy-policy', to: 'home#privacy_policy'
  get 'about-us', to: 'home#about_us'
  get 'terms-conditions', to: 'home#terms_conditions'
  
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  authenticate :user, lambda { |u| u.has_role?(:admin) } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
end
