
module Resin
  module Compiler
    CORE = ['boot', 'Kernel-Objects', 'Kernel-Classes', 'Kernel-Methods',
            'Kernel-Collections', 'Kernel-Exceptions', 'Canvas']

    def self.write_file(handle, filepath)
      package = File.basename(filepath).split('.').first
      puts "#{package} #{filepath}"
      handle.write("/* start #{package} */\n")
      handle.write(File.open(filepath, 'r').read)
      handle.write("\n/* end #{package} */\n")

    end

    def self.run(additional_files=nil)
      begin
        spec = Gem::Specification.find_by_name('resin')
        amber_path = File.join(spec.full_gem_path, 'amber')
      rescue Gem::LoadError
        amber_path = File.expand_path(File.dirname(__FILE__) + '/../amber/')
      end
      project_path = Dir.pwd


      files = Dir["#{project_path}/js/*.deploy.js"]
      drop_files = Dir["#{project_path}/drops/**/js/*.deploy.js"]
      out = File.open('resin-app.deploy.js', 'w')

      write_file(out, File.join(amber_path, 'js', 'lib', 'jQuery', 'jquery-1.6.4.min.js'))

      puts ">> Writing the Amber core: "
      CORE.each do |package|
        # Default to try to load the deploy script if it exists
        path = File.join(amber_path, 'js', "#{package}.deploy.js")
        unless File.exists? path
          path = File.join(amber_path, 'js', "#{package}.js")
          unless File.exists? path
            puts "Missing #{package}!"
            puts "(looked for #{path})"
            puts "Aborting."
            exit 1
          end
        end
        write_file(out, path)
      end
      puts

      puts ">> Writing project files: "
      files.each do |path|
        if path =~ /.*-Tests.*/
          next
        end
        write_file(out, path)
      end
      puts

      puts ">> Writing drop files: "
      drop_files.each do |path|
        if path =~ /.*-Tests.*/
          next
        end
        write_file(out, path)
      end
      puts

      unless additional_files.nil?
        additional_files.each do |path|
          path = File.join(project_path, 'js', additional_files)
          write_file(out, path)
        end
      end

      write_file(out, File.join(amber_path, 'js', 'init.js'))

      out.close

    end
  end
end

