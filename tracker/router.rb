require File.expand_path("tracker/subscriber_handler")
require File.expand_path("tracker/event_handler")

module Tracker
  class Router

    def initialize(app = nil)
      @app = app
    end

    def call(env)
      @request = Rack::Request.new(env)
      Router.routes.each do |location, operation|
        if @request.path =~ location
          return operation.call(env)
        end
      end
      return [404, {"Content-Type" => "application/json"},[JSON.generate({"message" => "Page not found"})]]
      # In order to implement as a middleware
      # @app.call(env) 
    end

    def self.routes
      {
        Regexp.new(/^\/events$/) => EventHandler.new { save_event },
        Regexp.new(/^\/subscribers$/) => SubscriberHandler.new{ save_subscriber },
        Regexp.new(/^\/test$/) => EventHandler.new{ test }
      }
    end

  end
end
