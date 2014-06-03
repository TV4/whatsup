module Whatsup
  class Railtie < Rails::Railtie
    config.whatsup = Whatsup::Configuration.new

    initializer "whatsup.configure_rack_middleware" do |app|
      app.middleware.use "Whatsup::StatusPage", config: app.config.whatsup
    end
  end
end
