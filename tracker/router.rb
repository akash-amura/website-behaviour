require File.expand_path("tracker/operations")

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
      return Operations.new { default }.call(env)
      # In order to implement as a middleware
      # @app.call(env) 
    end

    def self.routes
      {
        Regexp.new(/^\/track\/\d+\/info$/) => Operations.new { get_lead_tracking_info },
        Regexp.new(/^\/track$/) => Operations.new { save_lead_tracking_info }
      }
    end

  end
end
