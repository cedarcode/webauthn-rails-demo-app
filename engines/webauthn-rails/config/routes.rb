Webauthn::Rails::Engine.routes.draw do
  resource :registration, only: [:new, :create] do
    post :callback
  end

  resource :session, only: [:new, :create, :destroy] do
    post :callback
  end
end
