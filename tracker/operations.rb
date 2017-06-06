require 'pry'
require 'json'

module Tracker
  class Operations

    attr_reader :status, :headers, :body

    def initialize(&block)
      @block = block
      @status = 200
      @headers = {"Content-Type" => "application/json"}
    end

    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      @body = self.instance_eval(&@block)
      [status, headers, [body]]
    end

    def send_tracker_js
      JSON.generate({info: "Sending tracking info...."})
    end

    def get_lead_tracking_info
      JSON.generate({info: "Getting lead info....."})
    end

    def save_lead_tracking_info
      JSON.generate({info: "Saving lead tracking info....."})
    end

    def default
      @status = 404
      JSON.generate({info: "Page not found"})
    end
  end
end
