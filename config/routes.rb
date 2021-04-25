Rails.application.routes.draw do
  root "home#index"
  get "privacy_policy", to: "home#privacy_policy"
end
