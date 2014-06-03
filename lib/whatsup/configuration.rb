module Whatsup
  class Configuration
    attr_reader :collectors
    attr_accessor :username
    attr_accessor :password

    def initialize
      @collectors = {}

      if defined?(Resque)
        register(:job_queues, Whatsup::Collectors::ResqueStatus.new)
      end

      if defined?(::Rails)
        register(:cache, Whatsup::Collectors::CacheStatus.new)
        register(:rails, Whatsup::Collectors::RailsStatus.new)
      end

      if defined?(Toggle) && Toggle.respond_to?(:as_json)
        register(:toggles, ->() { Toggle.as_json })
      end

      if defined?(Sinatra)
        register(:sinatra, Whatsup::Collectors::SinatraStatus.new)
      end

      if defined?(Java)
        register(:java, Whatsup::Collectors::JavaStatus.new)
      end

      register(:ruby, Whatsup::Collectors::RubyStatus.new)

      register(:date, ->() { DateTime.now })
    end

    def register(key, collector)
      @collectors[key] = collector
    end
  end
end

