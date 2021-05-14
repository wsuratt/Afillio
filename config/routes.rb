Rails.application.routes.draw do
  devise_for :users
  resources :products
  
  resources :orders, :except => :edit, path_names: { new: ':title/:referral_token' }
  post 'orders/:title/:referral_token', to: 'orders#create'

  resources :users, only: [:index, :edit, :show, :update]
  
  root "home#index"
  get "how_it_works", to: "home#how_it_works"
  get "privacy-policy", to: "home#privacy_policy"
end
