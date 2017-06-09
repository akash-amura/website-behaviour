require File.expand_path('tracker/subscriber_handler')
require File.expand_path('tracker/event_handler')

module Tracker
  class Router
    def initialize(app = nil)
      @app = app
    end

    def call(env)
      @request = Rack::Request.new(env)
      Router.routes.each do |location, operation|
        return operation.call(env) if @request.path =~ location
      end
      [404, { 'Content-Type' => 'application/json' }, [JSON.generate('message' => 'Page not found')]]
      # In order to implement as a middleware
      # @app.call(env)
    end

    def self.routes
      {
        %r{/^\/events$/} => EventHandler.new { save_event },
        %r{/^\/subscribers$/} => SubscriberHandler.new { save_subscriber },
        %r{/^\/test$/} => EventHandler.new { test }
      }
    end
  end
end
