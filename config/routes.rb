Rails.application.routes.draw do
  devise_for :users
  
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
  
  root "home#index"
  get "how_it_works", to: "home#how_it_works"
  get "privacy-policy", to: "home#privacy_policy"
end
