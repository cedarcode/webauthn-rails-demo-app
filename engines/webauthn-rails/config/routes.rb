Webauthn::Rails::Engine.routes.draw do
  resource :registration, only: [:new, :create] do
    post :callback
  end
end
