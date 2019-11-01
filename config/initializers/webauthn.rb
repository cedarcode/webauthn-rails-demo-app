WebAuthn.configure do |config|
  config.origin = ENV["WEBAUTHN_ORIGIN"]
  config.rp_name = "WebAuthn Rails Demo App"
  config.metadata_token = ENV["MDS_TOKEN"]
  config.cache_backend = ActiveSupport::Cache::FileStore.new(
    Rails.root.join("tmp", "cache", "webauthn")
  )
end
