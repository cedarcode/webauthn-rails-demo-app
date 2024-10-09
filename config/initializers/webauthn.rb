# frozen_string_literal: true

WebAuthn.configure do |config|
  config.origin = Rails.configuration.webauthn_origin
  config.rp_name = "WebAuthn Rails Demo App"
end
