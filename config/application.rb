require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zenodotus
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths << Rails.root.join("lib/utilities")
    config.action_view.form_with_generates_remote_forms = false
    config.active_job.queue_adapter = :sidekiq

    # This lets Action Mailer generate URLs using the helper methods
    # TODO: This should be dynamic in the mailer based on the request subdomain.
    config.action_mailer.default_url_options = { host: Figaro.env.URL }

    config.action_mailer.delivery_method = :mailgun
    config.action_mailer.mailgun_settings = {
      api_key: Figaro.env.MAILGUN_API_KEY,
      domain: "mail.factcheckinsights.com"
    }
  end
end
