source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.4"

gem "rake"
gem "blueprinter"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.0.4"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
# gem "sass-rails", ">= 6"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# Use PgSearch for Postgres multi-table search
gem "pg_search", "~> 2.3.5"
# Use pagy to paginate ActiveRecord relations
gem "pagy", "~> 5.6"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# use sidekiq for job queueing
gem "sidekiq", "~> 6.5"
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  # Bullet is a gem to find and detect N+1 queries in development
  gem "bullet"

  # RuboCop is an excellent linter, we keep it in `test` for CI
  gem "rubocop", require: false
  gem "rubocop-rails", require: false # Rails specific styles
  gem "rubocop-rails_config", require: false # More Rails stuff
  gem "rubocop-performance", require: false # Performance checks
  gem "rubocop-sorbet", require: false # Check Sorbet
  gem "rubocop-minitest", require: false # For checking tests
  gem "minitest-hooks" # Used to apply stubs to each test

  gem "hotwire-livereload" # Live reload for JS, HTML and CSS devlopment
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"

  # Sorbet is a type-checker for Ruby. We prefer statically-defined types when possible
  gem "sorbet"
  # This is required for Ruby 3 from Sorbet
  gem "sorted_set"

  # Tmuxinator lets us set up standard development environments easily
  gem "tmuxinator"

  # We use Yard for all of our documentation
  gem "yard", require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Commenting out because we're not using Windows or JRuby and this throws a warning during bundler.
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# The production runtime for sorbet
gem "sorbet-runtime"

# Rails specific features for Sorbet
gem "sorbet-rails"

# For validating URL, the fork adds array of urls validation as well (yes, the difference in URL
# and gem name is on purpose)
gem "validate_url"

# Figaro lets us configure and require environment variable at boot, instead of getting stuck with a
# bad deployment
gem "figaro"

# Typhoneus handles URL request to outside websites extremely efficiently
gem "typhoeus"

# A headless chrome browser for interacting with website
gem "ferrum", "~> 0.11"

# Some basic OS checks, specifically to check to configure our scrapers for dev/prod
gem "os"

# Shrine is a better alternative to ActiveStorage for handling file attachments and the like
gem "shrine", "~> 3.0"

# A differential-hash library for image perceptual hashing. Surprisingly maintained.
# We don't have it versioned locked because it's been almost a year since one was released, but
# there's been plenty of commits
# gem "dhash-vips", git: "https://github.com/nakilon/dhash-vips/", tag: "v0.1.1.2"

gem "eikon"

# Stremio-ffmpeg use the ffmpeg library to process our video files
gem "streamio-ffmpeg"

# Scraper gems
# Local testing
# gem "zorki", "0.1.0", path: "~/Repositories/zorki" # instagram
# gem "birdsong", "0.1.0", path: "~/Repositories/birdsong" # twitter

# gem "zorki", "0.1.0", git: "https://github.com/cguess/zorki"
gem "birdsong", "0.1.0", git: "https://github.com/cguess/birdsong"
gem "forki", git: "https://github.com/TechAndCheck/forki"
gem "youtubearchiver", git: "https://github.com/TechAndCheck/YoutubeArchiver"

gem "terrapin"

# A progress bar for our Rake tasks
gem "ruby-progressbar"

# For validating JSON input on the API
gem "json_schemer"

# Devise is used for authentication and user management
gem "devise", "~> 4.8.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

gem "sprockets-rails", require: "sprockets/railtie"

# Jard is an improvement on Byebug
gem "ruby_jard"
gem "pry-byebug"

# Add the ability to load `.env` files on launch
gem "dotenv-rails"

# Code coverage so we can check if our tests actually cover everything
gem "simplecov", require: false

# Used to store our files in S3
gem "aws-sdk-s3"

# This enables reverse image and video searching
gem "zelkova"

# Generates a country selector for forms
# Also adds and uses the `countries` gem
gem "country_select", "~> 8.0"

# Used for sending email through Mailgun
gem "mailgun-ruby", "~> 1.2"

# Rolify is used for user roles
gem "rolify", "~> 6.0"

# We are temporarily using TailwindCSS to scaffold some layout
gem "tailwindcss-rails", "~> 2.0"

# We use SCSS to write more CSS more concisely
gem "dartsass-rails", "~> 0.4.0"

# Comma lets us generate CSV-formatted data from ActiveRecord models
gem "comma", "~>4.7.0"

# Webauthn Enabling
gem "webauthn", git: "https://github.com/cedarcode/webauthn-ruby", tag: "v3.0.0.alpha2"

# For TOTP one-time passcode (Firefox doesn't support passkeys)
gem "rotp", "~> 6.2"
# For generating the QRCode from the TOTP setup string
gem "rqrcode", "~> 2.0"
