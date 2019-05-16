WebAuthn.configure do |config|
  config.origin = ENV["WEBAUTHN_ORIGIN"]
end
