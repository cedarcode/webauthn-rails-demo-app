# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :session, only: [:new, :create, :destroy]
  resource :registrations, only: [:new, :create]

  resources :credentials, only: [:create, :destroy] do
    post :callback, on: :collection
  end

  post "session_callback", to: "sessions#callback"
  post "registration_callback", to: "registrations#callback"
  root to: "home#index"
end
