require 'bundler/gem_tasks'
require 'yard'

task :default => :test

desc 'Run tests'
task :test do
  Dir.chdir 'spec'
  system 'ruby -I ../lib spec.rb'
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
  t.options = ['--markup=markdown']
end
