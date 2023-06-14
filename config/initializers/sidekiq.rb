if ENV.has_key?("REDISCLOUD_URL")
  Sidekiq.configure_server do |config|
    config.redis = {
      url: ENV["REDISCLOUD_URL"],
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
        url: ENV["REDISCLOUD_URL"],
        ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    }
  end
end
