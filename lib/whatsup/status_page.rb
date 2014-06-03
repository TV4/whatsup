class Whatsup::StatusPage
  attr_reader :collectors, :config

  def initialize(app, config)
    @app = app
    @config = config
    @collectors = {}

    config.collectors.each do |key, collector|
      add_collector(key, collector)
    end
  end

  def call(env)
    if env["PATH_INFO"] == "/__status"
      whatsup.call(env)
    else
      @app.call(env)
    end
  end

  class App
    def initialize(app, sp)
      @app = app
      @sp = sp
    end

    def call(env)
      result = { }

      @sp.collectors.each do |key, collector|
        result[key] = collector.call
      end

      body = result.to_json

      req = Rack::Request.new(env)

      if req.params["callback"]
        body = "#{req.params["callback"]}(#{body})"
      end

      ['200', {"Content-Type" => "application/json"}, [body]]
    end
  end

  def add_collector(key, collector)
    @collectors[key] = collector
  end

  private

  def whatsup
    app = App.new(@app, self)

    authentication_required? ? wrap_with_rack_auth(app) : app
  end

  def authentication_required?
    if nil_credentials?
      raise ArgumentError, "Whatsup needs to be explicitly configured with a username and password (See README)"
    end

    !String(config.username).empty?
  end

  def nil_credentials?
    config.username.nil? || config.password.nil?
  end

  def wrap_with_rack_auth(app)
    Rack::Auth::Basic.new(app) do |username, password|
      username == config.username &&
        password == config.password
    end
  end
end
