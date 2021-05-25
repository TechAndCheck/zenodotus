source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.0"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
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

# Hotwire, to make better website without JS
gem "hotwire-rails"

# TailwindCSS
gem "tailwindcss-rails", "~> 0.3.3"

# A headless chrome browser for interacting with website
gem "ferrum", "~> 0.11"

# Some basic OS checks, specifically to check to configure our scrapers for dev/prod
gem "os"

# Scraper gems
# gem "zorki", "0.1.0", path: "~/Repositories/zorki" # instagram
gem "birdsong", "0.1.0", path: "~/Repositories/birdsong" # twitter
