Figaro.require_keys("TWITTER_BEARER_TOKEN", "INSTAGRAM_USER_NAME", "INSTAGRAM_PASSWORD")

# This is the salt value used to encrypt various things, you can generate one by running
# `rails secret`
Figaro.require_keys("KEY_ENCRYPTION_SALT")

# The URL and auth key for the external Zorki gem scraper
Figaro.require_keys("ZORKI_SERVER_URL")
Figaro.require_keys("ZORKI_AUTH_KEY")
