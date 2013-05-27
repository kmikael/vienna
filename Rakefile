require 'bundler/gem_tasks'

task :default => :test

desc 'Test'
task :test do
  Dir.chdir 'spec'
  system 'ruby -I lib spec.rb'
end
