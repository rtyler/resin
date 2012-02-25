require 'rubygems'
require 'sinatra/base'
require 'haml'

AMBER_PATH = File.expand_path('../../../amber', __FILE__)

module Resin
  def env
    ENV['RACK_ENV']
  end
  module_function :env

  def development?
    !(env == 'production')
  end
  module_function :development?

  class Server < Sinatra::Base
    set :dump_errors, true
    set :views,  File.expand_path('../views', __FILE__)

    def javascript_files
      return ''
      files = []
      Dir.glob("js/*.js") do |filename|
        unless filename.include? 'deploy'
          files << "\"#{File.basename(filename)}\""
        end
      end
      files.join(',')
    end

    get '/' do
      haml :index
    end

    get '/js/:filename' do |filename|
      amber_file = File.join(AMBER_PATH, '/js/', filename)
      if File.exists? amber_file
        return File.open(File.join(AMBER_PATH, '/js/', filename), 'r').read
      end
      halt 404
    end

    if Resin.development?
      set :logging, true
      disable :protection

      # Only enable the saving mechanism in test/development
      put '*' do
        unless request.body.nil?
          path = File.join(File.dirname(__FILE__), request.path)
          puts ">> Commiting changes to #{path}"
          File.open(path, 'w') do |fd|
            request.body.each do |line|
              fd.write(line)
            end
          end
        end
      end
    end
  end
end
