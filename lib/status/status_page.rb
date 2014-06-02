class Status::StatusPage
  attr_reader :collectors
  def initialize(app, options)
    @app = app

    @collectors = {}
    options[:config].collectors.each do |key, collector|
      add_collector(key, collector)
    end

    @username = options[:config].username || ENV['http_auth_user']
    @password = options[:config].password || ENV['http_auth_password']
  end

  def call(env)
    if env["REQUEST_PATH"] == "/__status"
      auth_app = Rack::Auth::Basic.new(App.new(@app, self)) do |username, password|
        username == @username && password == @password
      end

      auth_app.call(env)
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
      sleep 2

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
end
