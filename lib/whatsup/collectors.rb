require "yaml"

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
        cache: {
          type: Rails.cache.class.to_s,
          stats: (Rails.cache.respond_to?(:stats) ? Rails.cache.stats : nil)
        },
        version: Rails::VERSION::STRING
      }
    end
  end

  class RubyStatus
    def call
      {
        description: RUBY_DESCRIPTION,
        yamler: YAML.name,
        multi_json_engine: (defined?(MultiJson) ? MultiJson.engine.name : nil),
        gc: {
          count: GC.count,
          stat: (GC.respond_to?(:stat) ? GC.stat : nil),
        }
      }
    end
  end

  class SinatraStatus
    def call
      {
        version: Sinatra::VERSION
      }
    end
  end

  class JavaStatus
    def call
      Java.java.lang.System.properties.to_hash
    end
  end

  module Framework
    class Rails
      def call
        {
          name: "rails",
          version: ::Rails::VERSION::STRING
        }
      end
    end


    class Sinatra
      def call
        {
          name: "sinatra",
          version: ::Sinatra::VERSION
        }
      end
    end

    class Rack
      def call
        {
          name: "rack",
          version: ::Rack.release
        }
      end
    end
  end

  module Language
    class JRuby
      def call
        {
          name: "jruby",
          version: JRUBY_VERSION
        }
      end
    end

    class Ruby
      def call
        {
          name: "ruby",
          version: "#{RUBY_VERSION}p#{RUBY_PATCHLEVEL}"
        }
      end
    end
  end
end
