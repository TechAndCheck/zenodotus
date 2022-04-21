Figaro.require_keys("TWITTER_BEARER_TOKEN")

# This is the salt value used to encrypt various things, you can generate one by running
# `rails secret`
Figaro.require_keys("KEY_ENCRYPTION_SALT")

# The URL and auth key for Hypatia
Figaro.require_keys("HYPATIA_SERVER_URL")
Figaro.require_keys("HYPATIA_AUTH_KEY")

# Scraper-specific secrets
Figaro.require_keys("INSTAGRAM_USER_NAME", "INSTAGRAM_PASSWORD")
Figaro.require_keys("FACEBOOK_EMAIL", "FACEBOOK_PASSWORD")
Figaro.require_keys("TWITTER_BEARER_TOKEN")
Figaro.require_keys("YOUTUBE_API_KEY")


# The URL of the currently running server for Hypatia callbacks
Figaro.require_keys("URL")
