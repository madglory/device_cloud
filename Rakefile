require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Run a console with device_cloud loaded'
task :console do
  require 'device_cloud'
  require 'pry'
  require 'awesome_print'

  DeviceCloud.configure do |config|
    config.username = ENV['IDIGI_USERNAME']
    config.password = ENV['IDIGI_PASSWORD']
  end

  Pry.start
end
