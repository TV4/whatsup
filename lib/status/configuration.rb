module Status
  class Configuration
    attr_reader :collectors
    attr_accessor :username
    attr_accessor :password

    def initialize
      @collectors = {}

      if defined?(Resque)
        register(:job_queues, Status::Collectors::ResqueStatus.new)
      end

      if defined?(::Rails)
        register(:cache, Status::Collectors::CacheStatus.new)
        register(:rails, Status::Collectors::RailsStatus.new)
      end

      if defined?(Toggle) && Toggle.respond_to?(:as_json)
        register(:toggles, ->() { Toggle.as_json })
      end

      if defined?(Sinatra)
        register(:sinatra, Status::Collectors::SinatraStatus.new)
      end

      register(:ruby, Status::Collectors::RubyStatus.new)

      register(:date, ->() { DateTime.now })
    end

    def register(key, collector)
      @collectors[key] = collector
    end
  end
end

