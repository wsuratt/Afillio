Rails.application.routes.draw do
  devise_for :users
  resources :products
  resources :users, only: [:index]
  root "home#index"
  get "how_it_works", to: "home#how_it_works"
  get "privacy-policy", to: "home#privacy_policy"
end
