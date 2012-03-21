require 'rubygems'
require 'json'
require 'yaml'

module Resin
  module Helpers
    def self.append_js_file(filename, to_array)
      filename = File.basename(filename)

      if Resin.development?
        unless filename.include? 'deploy'
          to_array << filename
        end
        return
      end

      if (filename.include? 'deploy') && !(filename.include? '-Tests')
        to_array << filename
      end
    end

    def javascript_files
      files = []

      # First our project's files take precedence
      Dir.glob("#{Dir.pwd}/js/*.js") do |filename|
        Resin::Helpers.append_js_file(filename, files)
      end

      # Then our drops get loaded
      drops.each do |drop|
        unless drop[:meta]
          next
        end

        if drop[:js]
          drop[:js].each do |filename|
            Resin::Helpers.append_js_file(filename, files)
          end
        end
      end

      files
    end

    def find_template(views, name, engine, &block)
      Array(views).each do |view|
        super(view, name, engine, &block)
      end
    end

    def embed_amber(options={})
      deploy_line = ''
      unless Resin.development?
        deploy_line = "deploy: true,"
      end

      on_ready_function = options[:on_ready] || ''

      return <<-END
        <script type="text/javascript" src="/js/amber.js"></script>
        <script type="text/javascript">
          loadAmber({
            #{deploy_line}
            files : #{JSON.dump(javascript_files)},
            prefix : 'js',
            ready : function() { #{on_ready_function} }
          });
        </script>
      END
    end

    def load_resource(prefix, filename)
      # A file in our working directory will take precedence over the
      # Amber-bundled files. This should allow custom Kernel-Objects.js files
      # for example.
      local_file = File.join(Dir.pwd, "#{prefix}/", filename)
      amber_file = File.join(AMBER_PATH, "/#{prefix}/", filename)

      if File.exists? local_file
        File.open(local_file, 'r').read
      elsif File.exists? amber_file
        File.open(amber_file, 'r').read
      else
        nil
      end
    end

    def load_drop_resource(filename)
      drops.each do |drop|
        if drop.nil? or drop.empty? or drop[:js].empty?
          next
        end

        drop[:js].each do |drop_filepath|
          drop_filename = File.basename(drop_filepath)
          if filename == drop_filename
            return File.open(drop_filepath).read
          end
        end
      end
      nil
    end

    def content_type_for_ext(filename)
      if File.extname(filename) == '.js'
        content_type 'application/javascript'
      elsif File.extname(filename) == '.css'
        content_type 'text/css'
      else
        content_type 'text/plain'
      end
    end

    def load_drop_file(filepath)
      YAML::load(File.open(filepath).read)
    end

    def self.flush_drops
      @@drops = nil
      @@drops_map = {}
      @@drops_filemap = {}
    end

    def drops_map
      @@drops_map
    end

    def drops_filemap
      @@drops_filemap
    end

    def drops
      @@drops ||= begin
        @@drops_map ||= {}
        @@drops_filemap ||= {}
        drops_path = File.join(Dir.pwd, 'drops')
        loaded = []
        Dir.glob("#{drops_path}/*/drop.yml") do |filename|
          drop = load_drop_file(filename)
          if drop.nil? or drop.empty?
            next
          end
          drop_dir = File.dirname(filename)
          name = drop['drop']['name']
          puts ">>> Loading Resin Drop: #{name}"

          data = {:meta => drop['drop'],
                    :js => Dir[File.join(drop_dir, 'js', '*.js')],
                    :st => Dir[File.join(drop_dir, 'st', '*.st')]
                    }
          loaded << data

          @@drops_map[name] = drop_dir

          data[:js].each do |js|
            @@drops_filemap[File.basename(js)] = name
          end
          data[:st].each do |st|
            @@drops_filemap[File.basename(st)] = name
          end
        end
        loaded
      end
    end
  end
end
