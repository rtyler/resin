# -*- encoding: utf-8 -*-

spec = Gem::Specification.new do |s|
  s.name = 'resin'
  s.version = '0.1.0'
  s.author = "R. Tyler Croy"
  s.email = "tyler@linux.com"
  s.homepage = "https://github.com/rtyler/resin"
  s.platform = Gem::Platform::RUBY
  s.summary = %q{A tool for building Amber applications with Ruby}
  s.files = Dir['bin/*'] + Dir['lib/**/*.rb'] + Dir['lib/**/*.haml'] + Dir['amber/css/*'] +
            Dir['amber/js/**/*'] + Dir['amber/st/**/*.st'] + Dir['amber/images/*']
  s.bindir = 'bin'
  s.executables = ['runresin']
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.markdown"]

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "shotgun"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rack-test"

  s.add_dependency 'thin'
  s.add_dependency 'haml'
  s.add_dependency 'sinatra'
  s.add_dependency 'json'
end
