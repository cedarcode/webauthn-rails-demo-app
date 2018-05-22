Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:create]
  post "callback", to: "sessions#callback"
  root to: "sessions#new"
end
