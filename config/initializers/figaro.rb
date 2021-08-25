Figaro.require_keys("TWITTER_BEARER_TOKEN", "INSTAGRAM_USER_NAME", "INSTAGRAM_PASSWORD")

# This is the salt value used to encrypt various things, you can generate one by running
# `rails secret`
Figaro.require_keys("KEY_ENCRYPTION_SALT")
