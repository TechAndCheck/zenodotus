source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.0"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# Use PgSearch for Postgres multi-table search
gem "pg_search", "~> 2.3.5"
# Use Scenic to create and maintain a materialized view
gem "scenic", "~> 1.5.4"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  # Bullet is a gem to find and detect N+1 queries in development
  gem "bullet"

  # Add the ability to load `.env` files on launch
  gem "dotenv-rails"

  # Jard is an improvement on Byebug
  gem "ruby_jard"
  gem "pry-byebug"

  # RuboCop is an excellent linter, we keep it in `test` for CI
  gem "rubocop", require: false
  gem "rubocop-rails", require: false # Rails specific styles
  gem "rubocop-rails_config", require: false # More Rails stuff
  gem "rubocop-performance", require: false # Performance checks
  gem "rubocop-sorbet", require: false # Check Sorbet
  gem "rubocop-minitest", require: false # For checking tests
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

  # Code coverage so we can check if our tests actually cover everything
  gem "simplecov", require: false
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

# Hotwire, to make better website without JS
gem "hotwire-rails"

# TailwindCSS
gem "tailwindcss-rails", "~> 0.3.3"

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

#gem "eikon", path: "~/Repositories/eikón/eikon"
gem "eikon", git: "https://github.com/cguess/eikon"
# Stremio-ffmpeg use the ffmpeg library to process our video files
gem "streamio-ffmpeg"

# Scraper gems
# Local testing
# gem "zorki", "0.1.0", path: "~/Repositories/zorki" # instagram
# gem "birdsong", "0.1.0", path: "~/Repositories/birdsong" # twitter

# gem "zorki", "0.1.0", git: "https://github.com/cguess/zorki"
gem "birdsong", "0.1.0", git: "https://github.com/cguess/birdsong"

# A progress bar for our Rake tasks
gem "ruby-progressbar"

# For validating JSON input on the API
gem "json_schemer"

# Devise is used for authentication and user management
gem "devise", "~> 4.8.0"

# New way to bundle CSS and JS for Rails 7
gem "cssbundling-rails"
gem "importmap-rails"

# Use Stimulus for Rails 7
gem "stimulus-rails"