# frozen_string_literal: true

require File.expand_path('tracker/datastore')

module Tracker
  class Event
    attr_reader :id

    def initialize(event_hash)
      @hash = pre_process(event_hash)
      @id = nil
    end

    def store
      datastore = Datastore.new('Event')
      @id = datastore.insert(@hash).key.id
    end

    def notify
      return unless id
      datastore = Datastore.new('Subscriber')
      subscribers = datastore.query { |q| q.where('client_id', '=', @hash['client_id']) }
      subscribers.each do |subscriber|
        uri = URI(subscriber['url'])
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = @hash.to_json
        Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
      end
    end

    private

    def pre_process(hash)
      hash
    end
  end
end
