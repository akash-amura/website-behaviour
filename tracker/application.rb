require File.expand_path('tracker/router')

module Tracker
  def self.application
    Rack::Builder.new do
      use Rack::Static, urls: ['/public']
      run Router.new
    end
  end
end
