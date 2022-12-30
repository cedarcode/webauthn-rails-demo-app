WebAuthn.configure do |config|
  config.origin = ENV["WEBAUTHN_ORIGIN"]
  config.rp_name = "Ad Hoc WebAuthn Demo"
end
