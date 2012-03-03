
module Resin
  module Helpers
    def javascript_files
      files = []
      Dir.glob("#{Dir.pwd}/js/*.js") do |filename|
        if Resin.development?
          unless filename.include? 'deploy'
            files << "\"#{File.basename(filename)}\""
          end
        else
          if filename.include? 'deploy'
            files << "\"#{File.basename(filename)}\""
          end
        end
      end
      files.join(',')
    end

    def find_template(views, name, engine, &block)
      Array(views).each do |view|
        super(view, name, engine, &block)
      end
    end

    def embed_amber
      deploy_line = ''
      unless Resin.development?
        deploy_line = "deploy: true,"
      end
      return <<-END
        <script type="text/javascript" src="/js/amber.js"></script>
        <script type="text/javascript">
          loadAmber({
            #{deploy_line}
            files : [#{javascript_files}],
            ready : function() { }
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

    def content_type_for_ext(filename)
      if File.extname(filename) == '.js'
        content_type 'application/javascript'
      elsif File.extname(filename) == '.css'
        content_type 'text/css'
      else
        content_type 'text/plain'
      end
    end
  end
end
