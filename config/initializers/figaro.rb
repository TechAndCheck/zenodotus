Figaro.require_keys("TWITTER_BEARER_TOKEN")

# This is the salt value used to encrypt various things, you can generate one by running
# `rails secret`
Figaro.require_keys("KEY_ENCRYPTION_SALT")

# The URL and auth key for the external Zorki gem scraper
Figaro.require_keys("ZORKI_SERVER_URL")
Figaro.require_keys("ZORKI_AUTH_KEY")

# The URL and auth key for the external Forki gem scraper
Figaro.require_keys("FORKI_SERVER_URL")
Figaro.require_keys("FORKI_AUTH_KEY")
