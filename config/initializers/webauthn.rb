WebAuthn.configure do |config|
  config.origin = ENV.fetch("APP_URL", "https://vault-factstream-reporterslab.pagekite.me")
  config.rp_name = "Media Vault"
  config.credential_options_timeout = 120_000
end
