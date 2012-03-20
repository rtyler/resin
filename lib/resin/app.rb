require 'rubygems'
require 'sinatra/base'
require 'haml'

require File.expand_path(File.dirname(__FILE__) + '/helpers.rb')

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
    set :port, ENV['PORT'] || 4567
    set :views, [File.join(Dir.pwd, 'views'), File.expand_path('../views', __FILE__)]

    helpers do
      include Resin::Helpers
    end

    get '/' do
      haml :index
    end

    get '/:view' do |view|
      begin
        haml view.to_sym
      rescue ::Errno::ENOENT
        halt 404, 'Not found'
      end
    end

    ['js', 'css', 'images'].each do |path|
      get "/#{path}/*" do |filename|
        content_type_for_ext filename
        data = load_resource(path, filename)
        if data.nil?
          halt 404, 'Not found'
        end
        data
      end
    end

    if Resin.development?
      set :logging, true
      disable :protection

      # Only enable the saving mechanism in test/development
      put '*' do
        unless request.body.nil?
          filename = request.path.split('/')[-1]
          directory = '/st/'
          if filename.end_with? '.js'
            directory = '/js/'
          end
          path = File.join(Dir.pwd, directory, filename)
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
