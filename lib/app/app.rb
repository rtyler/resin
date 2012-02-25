require 'rubygems'
require 'sinatra'
require 'haml'


set :dump_errors, true
set :static, true
set :public_folder, File.dirname(__FILE__)

def development?
  !(ENV['RACK_ENV'] == 'production')
end

def javascript_files
  files = []
  Dir.glob("js/*.js") do |filename|
    unless filename.include? 'deploy'
      files << "\"#{File.basename(filename)}\""
    end
  end
  files.join(',')
end


get '/', :provides => 'html'  do
  haml :index
end

if development?
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

