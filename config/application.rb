require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Estimasphere
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework false
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.assets.compile = true #追加

    # Add the following line to your config/application.rb
    config.assets.enabled = true #追加

    # Moved inside the Application class
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/customers/search', headers: :any, methods: [:get]
      end
    end
  end
end
