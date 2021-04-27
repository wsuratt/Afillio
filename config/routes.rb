Rails.application.routes.draw do
  resources :products
  root "home#index"
  get "privacy_policy", to: "home#privacy_policy"
end
