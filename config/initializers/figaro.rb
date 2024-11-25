# This is the salt value used to encrypt various things, you can generate one by running
# `rails secret`
Figaro.require_keys("KEY_ENCRYPTION_SALT")

# The URL and auth key for Hypatia
Figaro.require_keys("HYPATIA_SERVER_URL")
Figaro.require_keys("HYPATIA_AUTH_KEY")

# The host names for the apps, used for routing requests to the appropriate app
Figaro.require_keys("FACT_CHECK_INSIGHTS_HOST")
Figaro.require_keys("MEDIA_VAULT_HOST")
Figaro.require_keys("AUTH_BASE_HOST") # This is used by MFA as the site id

# Settings for sending email
Figaro.require_keys("MAIL_DOMAIN")
Figaro.require_keys("MAILGUN_API_KEY")

# Public links
Figaro.require_keys("PUBLIC_LINK_HOST")

Figaro.require_keys("NEO4J_URL")
Figaro.require_keys("NEO4J_USERNAME")
Figaro.require_keys("NEO4J_PASSWORD")

if Figaro.env.USE_S3_DEV_TEST == "true" || Rails.env == "production"
  Figaro.require_keys("AWS_REGION")
  Figaro.require_keys("AWS_S3_BUCKET_NAME")
  Figaro.require_keys("AWS_ACCESS_KEY_ID")
  Figaro.require_keys("AWS_SECRET_ACCESS_KEY")
end

if Rails.env == "production"
  Figaro.require_keys("MEMCACHIER_SERVERS")
  Figaro.require_keys("MEMCACHIER_USERNAME")
  Figaro.require_keys("MEMCACHIER_PASSWORD")
end

if Figaro.env.HONEYBADGER_API_KEY.blank? == false
  Figaro.require_keys("HONEYBADGER_API_KEY_GOOGLE_CHECK_IN_ADDRESS")
  Figaro.require_keys("HONEYBADGER_API_KEY_CSV_JSON_GENERATION_ADDRESS")
end

Figaro.require_keys("OLLAMA_URL")
Figaro.require_keys("OLLAMA_PASSWORD")
Figaro.require_keys("FACTCHECK_TOOLS_API_KEY")

Figaro.require_keys("DEVISE_JWT_SECRET_KEY")
