# frozen_string_literal: true

require File.expand_path('tracker/subscriber')
require 'pry'

module Tracker
  class SubscriberHandler
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

    def save_subscriber
      data = @request.body.read
      received_data = JSON.parse(data) if data && data.length >= 2
      subscriber = Subscriber.new(received_data)
      subscriber.store
      if subscriber.id
        JSON.generate(message: "subscriber successfully saved with id #{subscriber.id}")
      else
        @status = 500
        JSON.generate(message: 'subscriber save unsuccessful')
      end
    end
  end
end
