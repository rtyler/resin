require 'rubygems'
require 'rspec'
require 'rack/test'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')

require 'sinatra/resin'

Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :raise_errors, true
Sinatra::Base.set :logging, false

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

class FakeApp < Sinatra::Base
  register Sinatra::Resin
end
