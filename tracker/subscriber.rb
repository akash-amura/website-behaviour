# frozen_string_literal: true

require File.expand_path('tracker/datastore')

module Tracker
  class Subscriber
    attr_reader :id

    def initialize(subscriber_hash)
      @hash = pre_process(subscriber_hash)
      @id = nil
    end

    def store
      datastore = Datastore.new('Subscriber')
      @id = datastore.insert(@hash).key.id
    end

    private

    def pre_process(hash)
      hash
    end
  end
end
