require 'spec_helper'

describe Sinatra::Resin do
  def app
    FakeApp
  end

  it 'generates an index page' do
    get '/'
    last_response.should be_ok
  end

  it 'serves amber.js properly' do
    get '/js/amber.js'
    last_response.should be_ok
  end

  it 'should 404 on JS that doesn\'t exist' do
    get '/js/make-believe.js'
    last_response.should be_not_found
  end

  describe '#development?' do
    it 'should be false when in production' do
      Sinatra::Resin.should_receive(:env).and_return('production')
      Sinatra::Resin.development?.should be false
    end

    it 'should be true when in development' do
      Sinatra::Resin.should_receive(:env).and_return('development')
      Sinatra::Resin.development?.should be true
    end

    it 'should be true by default (i.e. no RACK_ENV)' do
      Sinatra::Resin.should_receive(:env).and_return(nil)
      Sinatra::Resin.development?.should be true
    end
  end
end
