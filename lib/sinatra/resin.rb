require 'sinatra/base'
require 'sinatra/resin/helpers'
require 'haml'

module Sinatra
  module Resin
    AMBER_PATH = File.expand_path('../../../amber', __FILE__)

    def env
      ENV['RACK_ENV']
    end
    module_function :env

    def development?
      !(env == 'production')
    end
    module_function :development?

    def self.registered(app)
      app.helpers Sinatra::Resin::Helpers
      app.set :dump_errors, true
      app.set :port, ENV['PORT'] || 4567
      app.set :views, [File.join(Dir.pwd, 'views'), File.expand_path('../../resin/views', __FILE__)]

      app.before do
        # Make sure to call Sinatra::Resin::Helpers#drops to load all our drops
        drops
      end

      app.get '/' do
        haml :index
      end

      app.get '/:view/?' do |view|
        begin
          haml view.to_sym
        rescue ::Errno::ENOENT
          halt 404, 'Not found'
        end
      end

      ['js', 'css', 'images'].each do |path|
        app.get "/#{path}/*" do |filename|
          content_type_for_ext filename
          data = load_resource(path, filename)
          if data.nil? and path == 'js'
            data = load_drop_resource(filename)
          end

          if data.nil?
            halt 404, 'Not found'
          end

          data
        end
      end

      if development?
        app.set :logging, true
        app.disable :protection

        # Only enable the saving mechanism in test/development
        app.put '*' do
          unless request.body.nil?
            filename = request.path.split('/')[-1]
            directory = '/st/'
            if filename.end_with? '.js'
              directory = '/js/'
            end

            root_dir = Dir.pwd

            if drops_filemap[filename]
              drop_name = drops_filemap[filename]
              root_dir = drops_map[drop_name]
            end

            path = File.join(root_dir, directory, filename)
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

  register Resin

end
