WebAuthn.configure do |config|
  config.origin = ENV.fetch("AUTH_BASE_HOST")
  config.rp_name = "FactCheck Insights/MediaVault"
  config.credential_options_timeout = 120_000
end
