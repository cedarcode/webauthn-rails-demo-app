Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:new, :create]

  resources :users, only: [] do
    resources :credentials, only: [:create] do
      post :callback, on: :collection
    end
  end

  post "callback", to: "sessions#callback"
  root to: "home#index"
end
