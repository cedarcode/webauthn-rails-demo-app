WebAuthn.configure do |config|
  config.origin = ENV["WEBAUTHN_ORIGIN"]
  config.rp_name = "WebAuthn Rails Demo App"

  config.algorithms = ["EdDSA"]
end
