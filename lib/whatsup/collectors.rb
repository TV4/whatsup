module Whatsup::Collectors
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
          time_zone: Rails.configuration.time_zone,
          log_level: Rails.configuration.log_level,
          rack_cache: Rails.configuration.action_dispatch
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
        multi_json_engine: (defined?(MultiJson) ? MultiJson.engine.name : nil),
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

  class JavaStatus
    def call
      {
        properties: Java.java.lang.System.properties.to_hash
      }
    end
  end
end
