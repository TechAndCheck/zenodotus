Figaro.require_keys("TWITTER_BEARER_TOKEN")

# This is the salt value used to encrypt various things, you can generate one by running
# `rails secret`
Figaro.require_keys("KEY_ENCRYPTION_SALT")

# The URL and auth key for Hypatia
Figaro.require_keys("HYPATIA_SERVER_URL")
Figaro.require_keys("HYPATIA_AUTH_KEY")

# The URL of the currently running server, used for configuring Action Mailer and Hypatia callbacks
Figaro.require_keys("URL")

# Mailgun settings for sending email
Figaro.require_keys("MAILGUN_API_KEY")

if Figaro.env.USE_S3_DEV_TEST == "true" || Rails.env == "production"
  Figaro.require_keys("AWS_REGION")
  Figaro.require_keys("AWS_ACCESS_KEY_ID")
  Figaro.require_keys("AWS_SECRET_ACCESS_KEY")
end
