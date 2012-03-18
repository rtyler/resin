require File.dirname(__FILE__) + '/spec_helper'

describe Resin::Helpers do
  include Resin::Helpers

  describe '#javascript_files' do
    it 'should return an empty string if there are no files' do
      Dir.stub(:glob)
      javascript_files.should be_instance_of(String)
      javascript_files.should be_empty
    end

    it 'should return a single filename as string for one file' do
      Dir.should_receive(:glob).and_yield('hello.js')
      javascript_files.should == '"hello.js"'
    end

    it 'should return a comma-separated string for multiple files' do
      Dir.should_receive(:glob).and_yield('hello.js').and_yield('goodbye.js')
      javascript_files.should == '"hello.js","goodbye.js"'
    end

    it 'should ignore deploy files by default' do
      Dir.stub(:glob).and_yield('hello.deploy.js')
      javascript_files.should be_empty
    end

    it 'should only include deploy files when in production' do
      Resin.stub(:development?).and_return(false)
      Dir.stub(:glob).and_yield('hello.deploy.js').and_yield('ignore.js')
      javascript_files.should == '"hello.deploy.js"'
    end

    it 'should exclude -Tests files when in production' do
      Resin.stub(:development?).and_return(false)
      Dir.stub(:glob).and_yield('Hello-Tests.deploy.js').and_yield('Hello.deploy.js')
      javascript_files.should == '"Hello.deploy.js"'

    end

    context 'when there are resin drops available' do

    end
  end
end
