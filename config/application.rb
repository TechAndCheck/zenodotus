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

    # This is necessary for Action Mailer to generate URLs using the helper methods without
    # having to specify the `host` option each time.
    #
    # Since this application hosts multiple sites, our URLs are context-specific, and so this will
    # often be over-ridden inline. However, we want to fall back to the primary Insights URL.
    config.action_mailer.default_url_options = { host: Figaro.env.FACT_CHECK_INSIGHTS_URL }

    config.action_mailer.delivery_method = :mailgun
    config.action_mailer.mailgun_settings = {
      api_key: Figaro.env.MAILGUN_API_KEY,
      domain: Figaro.env.MAIL_DOMAIN,
    }
  end
end
