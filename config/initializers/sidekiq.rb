# debugger
# method = Sidekiq.server? ? :configure_server : :configure_client
# Sidekiq.public_send(method) { |cfg| cfg.logger = SemanticLogger[Sidekiq] }

if ENV.has_key?("REDISCLOUD_URL")
  Sidekiq.configure_server do |config|
    config.redis = {
      url: ENV["REDISCLOUD_URL"],
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    }

    module SemanticLoggerSidekiqContext
      def log(log, *args)
        log.assign_hash(Sidekiq::Context.current)
        super
      end
    end

    SemanticLogger::Logger.prepend(SemanticLoggerSidekiqContext)
  end

  Sidekiq.configure_client do |config|
    config.redis = {
        url: ENV["REDISCLOUD_URL"],
        ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    }

    module SemanticLoggerSidekiqContext
      def log(log, *args)
        log.assign_hash(Sidekiq::Context.current)
        super
      end
    end

    SemanticLogger::Logger.prepend(SemanticLoggerSidekiqContext)
  end
end
