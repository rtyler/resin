require 'thor'

module Resin
  class CLI < Thor
    desc 'start', 'Run the current Resin application'
    def start
      require 'sinatra/base'
      require 'sinatra/resin'
      Sinatra::Application.run!
    end


    desc 'compile', 'Compile all the Amber and JavaScripts together'
    def compile
      require 'resin/compiler'
      Resin::Compiler.run
    end
  end
end
