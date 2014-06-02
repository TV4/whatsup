module Status
  class Railtie < Rails::Railtie
    config.status_page = Status::Configuration.new

    initializer "status.configure_rack_middleware" do |app|
      app.middleware.use "Status::StatusPage", config: app.config.status_page
    end
  end
end
