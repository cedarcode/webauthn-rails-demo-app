Webauthn::Rails::Engine.routes.draw do
  resource :registration, only: [:new, :create] do
    post :callback
  end

  resource :session, only: [:new, :create, :destroy] do
    post :callback
  end

  resources :credentials, only: [:create, :destroy] do
    post :callback, on: :collection
  end
end
