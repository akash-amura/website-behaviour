require 'google/cloud/datastore'

module Tracker
  class EventStore

    def initialize
      @project_id = ENV["GOOGLE_CLOUD_PROJECT"] 
      @datastore = Google::Cloud::Datastore.new project: @project_id
      @kind = "Event"
    end

    def insert(event_hash)
      keys = event_hash.keys()
      event = @datastore.entity @kind do |e|
          keys.each do |k|
            e[k] = event_hash[k]
          end
        end
      @datastore.save event
      event
    end

  end
end
