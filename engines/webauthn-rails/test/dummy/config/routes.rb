Rails.application.routes.draw do
  mount Webauthn::Rails::Engine => "/webauthn-rails"
end
