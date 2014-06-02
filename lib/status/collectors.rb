module Status::Collectors
  class ResqueStatus
    def call
      Resque.queues.inject({}) do |hsh, queue_name|
        hsh[queue_name] = { length: Resque.size(queue_name) }
        hsh
      end
    end
  end

  class RailsStatus
    def call
      {
        middlewares: Rails.application.config.middleware.collect { |m| m.name },
        rails_env: Rails.env,
        rack_env: ENV['RACK_ENV'],
        config: {
          allow_concurrency: Rails.configuration.allow_concurrency,
          time_zone: Rails.configuration.time_zone
        },
        version: Rails::VERSION::STRING
      }
    end
  end

  class RubyStatus
    def call
      {
        description: RUBY_DESCRIPTION,
        yamler: YAML::ENGINE.yamler,
        gc: {
          count: GC.count,
          stat: (GC.respond_to?(:stat) ? GC.stat : nil),
        }
      }
    end
  end

  class CacheStatus
    def call
      {
        type: Rails.cache.class.to_s,
        stats: (Rails.cache.respond_to?(:stats) ? Rails.cache.stats : nil)
      }
    end
  end

  class SinatraStatus
    def call
      {
        version: Sinatra::VERSION,
      }
    end
  end
end
