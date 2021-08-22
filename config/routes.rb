Rails.application.routes.draw do
  devise_for :users
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user

  resources :products do
    get :purchased, :created, on: :collection
  end
  
  resources :orders, path_names: { edit: ':id/edit', new: ':title/:referral_token' } do
    get :my_orders, on: :collection
    get :my_sales, on: :collection
  end
  post 'orders/:title/:referral_token', to: 'orders#create'
  
  resources :users, only: [:index, :edit, :show, :update]
  
  post "checkout/create", to: "checkout#create"
  get "checkout/success", to: "checkout#success"
  resources :webhooks, only: [:create]
  
  get "stripe/connect", to: "stripe#connect", as: :stripe_connect
  get "payout/transfer", to: "payout#transfer"
  
  root "home#index"
  get "how-it-works", to: "home#how_it_works"
  get "privacy-policy", to: "home#privacy_policy"
  get "about-us", to: "home#about_us"
  get "become-vendor", to: "home#become_vendor"
  get "terms-conditions", to: "home#terms_conditions"
  
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'
  
end
