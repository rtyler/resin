require File.dirname(__FILE__) + '/spec_helper'


describe Resin do
  def app
    Resin::Server
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
      Resin.should_receive(:env).and_return('production')
      Resin.development?.should be false
    end

    it 'should be true when in development' do
      Resin.should_receive(:env).and_return('development')
      Resin.development?.should be true
    end

    it 'should be true by default (i.e. no RACK_ENV)' do
      Resin.should_receive(:env).and_return(nil)
      Resin.development?.should be true
    end
  end
end
