Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  resources :users, only: [:show]
  get "up" => "rails/health#show", as: :rails_health_check
  
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
end
