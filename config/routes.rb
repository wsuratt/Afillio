Rails.application.routes.draw do
  devise_for :users
  resources :products
  root "home#index"
  get "privacy_policy", to: "home#privacy_policy"
end
