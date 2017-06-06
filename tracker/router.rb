require File.expand_path("tracker/operations")
module Tracker
  class Router
    def initialize()
    end

    def call(env)
      @request = Rack::Request.new(env)
      Router.routes.each do |location, operation|
        if @request.path =~ location
          return operation.call(env)
        end
      end
      return Operations.new { default }.call(env)
    end

    def self.routes
      {
        Regexp.new(/^\/track\/\d+\/info$/) => Operations.new { get_lead_tracking_info },
        Regexp.new(/^\/track$/) => Operations.new { save_lead_tracking_info }
      }
    end
  end
end
