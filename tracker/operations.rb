require 'pry'
require 'json'
require File.expand_path('tracker/event_store')

module Tracker
  class Operations

    attr_reader :status, :headers, :body

    def initialize(&block)
      @block = block
      @status = 200
      @headers = {"Content-Type" => "application/json"}
      @event_store = EventStore.new
    end

    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      @body = self.instance_eval(&@block)
      [status, headers, [body]]
    end

    def save_lead_tracking_info
      data = @request.body.read
      received_data = JSON.parse(data) if data && data.length >= 2
      event = @event_store.insert(received_data)
      if event.key.id 
        JSON.generate({message: "event successfully saved with id #{event.key.id}"})
      else
        @status = 406
        JSON.generate({message: "event save unsuccessful"})
      end
    end

    def default
      @status = 404
      JSON.generate({info: "Page not found"})
    end
  end
end
