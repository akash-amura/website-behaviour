# frozen_string_literal: true

require File.expand_path('tracker/event')

module Tracker
  class EventHandler
    attr_reader :status, :headers, :body

    def initialize(&block)
      @block = block
      @status = 200
      @headers = { 'Content-Type' => 'application/json' }
    end

    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      @body = instance_eval(&@block)
      [status, headers, [body]]
    end

    def save_event
      data = @request.body.read
      received_data = JSON.parse(data) if data && data.length >= 2
      event = Event.new(received_data)
      event.store
      Thread.new do
        event.notify
      end
      if event.id
        JSON.generate(message: "event successfully saved with id #{event.id}")
      else
        @status = 500
        JSON.generate(message: 'event save unsuccessful')
      end
    end

    def test
      data = @request.body.read
      received_data = JSON.parse(data) if data && data.length >= 2
      JSON.generate(message: received_data.inspect.to_s)
    end
  end
end
