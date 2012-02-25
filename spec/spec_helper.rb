require 'rubygems'
require 'rspec'
require 'rack/test'

require File.join(File.dirname(__FILE__), "/../lib/resin/app/app.rb")

Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :raise_errors, true
Sinatra::Base.set :logging, false

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
