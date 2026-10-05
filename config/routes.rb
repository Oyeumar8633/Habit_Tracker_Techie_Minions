Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "habits#index"

  resources :habits do
    resources :check_ins, only: [:new, :create]
  end

  resources :check_ins, only: [:show, :edit, :update, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end