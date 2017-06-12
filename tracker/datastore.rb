# frozen_string_literal: true

require 'google/cloud/datastore'

module Tracker
  class Datastore
    attr_reader :store, :kind

    def initialize(kind)
      raise 'Google cloud project is not defined in environment variable' unless ENV['GOOGLE_CLOUD_PROJECT']
      @store = Google::Cloud::Datastore.new project: ENV['GOOGLE_CLOUD_PROJECT']
      @kind = kind
      test_connection
    end

    def insert(hash)
      raise ArgumentError, 'expected hash of key-value pairs' if hash.nil? || !hash.is_a?(Hash)
      keys = hash.keys()
      entity = @store.entity @kind do |e|
        keys.each do |k|
          e[k] = hash[k]
        end
      end
      @store.save entity
      entity.key.id ? entity : false
    end

    def delete(args) end

    def update(args) end

    def query
      raise ArgumentError, 'query method expects a block' unless block_given?
      query = yield(store.query(@kind))
      store.run query
    end

    private

    def test_connection
      @store.run @store.query(@kind).limit(1)
    end
  end
end
