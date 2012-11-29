require 'spec_helper'

describe Sinatra::Resin::Helpers do
  include Sinatra::Resin::Helpers

  describe '#javascript_files' do
    # Stub out the #drops method for these tests
    let(:drops) { [] }

    it 'should return an empty string if there are no files' do
      Dir.stub(:glob)
      javascript_files.should be_instance_of(Array)
      javascript_files.should be_empty
    end

    it 'should return a single filename as string for one file' do
      Dir.should_receive(:glob).and_yield('hello.js')
      javascript_files.should == ["hello.js"]
    end

    it 'should return a comma-separated string for multiple files' do
      Dir.should_receive(:glob).and_yield('hello.js').and_yield('goodbye.js')
      javascript_files.should == ["hello.js","goodbye.js"]
    end

    it 'should ignore deploy files by default' do
      Dir.stub(:glob).and_yield('hello.deploy.js')
      javascript_files.should be_empty
    end

    it 'should only include deploy files when in production' do
      Sinatra::Resin.stub(:development?).and_return(false)
      Dir.stub(:glob).and_yield('hello.deploy.js').and_yield('ignore.js')
      javascript_files.should == ["hello.deploy.js"]
    end

    it 'should exclude -Tests files when in production' do
      Sinatra::Resin.stub(:development?).and_return(false)
      Dir.stub(:glob).and_yield('Hello-Tests.deploy.js').and_yield('Hello.deploy.js')
      javascript_files.should == ["Hello.deploy.js"]
    end
  end

  describe '#drops' do
    before :each do
      Sinatra::Resin::Helpers.flush_drops
    end

    it 'should return nil if there are no drops available' do
      Dir.stub(:glob)
      drops.should be_instance_of(Array)
      drops.should be_empty
    end

    it 'should load globbed drop.yaml files' do
      Dir.should_receive(:glob).and_yield('drop.yaml')
      should_receive(:load_drop_file).with('drop.yaml')
      drops.should_not be_nil
    end
  end
end
