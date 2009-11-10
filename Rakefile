require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the aegis gem.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the aegis plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Aegis'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  gem 'jeweler', '>= 1.3.0'
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "bmaland-aegis"
    gemspec.summary = "Role-based permissions for your user models."
    gemspec.email = "github@makandra.de"
    gemspec.homepage = "http://github.com/bmaland/aegis"
    gemspec.description = "Aegis is a role-based permission system, where all users are given a role. It is possible to define detailed and complex permissions for each role very easily."
    gemspec.authors = ["Henning Koch"]
    gemspec.version = '1.1.5'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Jeweler::GemcutterTasks.new
