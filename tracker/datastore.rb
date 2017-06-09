require 'google/cloud/datastore'

module Tracker
  class Datastore

    attr_reader :store

    def initialize(kind)
      @store = Google::Cloud::Datastore.new project: ENV["GOOGLE_CLOUD_PROJECT"]
      @kind = kind
    end

    def insert(hash)
      keys = hash.keys()
      entity = @store.entity @kind do |e|
          keys.each do |k|
            e[k] = hash[k]
          end
        end
      @store.save entity
      entity
    end

    def delete(args)
    end

    def update(args)
    end

    def query
      if block_given?
        query = yield(store.query(@kind))
        store.run query
      else
        raise ArgumentError, "query method expects a block"
      end
    end
  end
end
