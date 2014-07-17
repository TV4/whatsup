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
        register(:rails, Whatsup::Collectors::RailsStatus.new)
      end

      if defined?(Java)
        register(:java, Whatsup::Collectors::JavaStatus.new)
      end

      register(:ruby, Whatsup::Collectors::RubyStatus.new)

      if defined?(::Rails)
        register(:framework, Whatsup::Collectors::Framework::Rails.new)
      elsif defined(Sinatra)
        register(:framework, Whatsup::Collectors::Framework::Sinatra.new)
      else
        register(:framework, Whatsup::Collectors::Framework::Rack.new)
      end

      if defined?(Java)
        register(:language, Whatsup::Collectors::Language::JRuby.new)
      else
        register(:language, Whatsup::Collectors::Language::Ruby.new)
      end

      register(:date, ->() { DateTime.now })
    end

    def register(key, collector)
      @collectors[key] = collector
    end
  end
end
