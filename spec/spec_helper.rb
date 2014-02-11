require 'device_cloud'
require 'ostruct'
require 'webmock/rspec'
require 'pry'
require 'awesome_print'

def idigi_username
  'foouser'
end

def idigi_password
  'barpass'
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:each) do
    DeviceCloud.configure do |configuration|
      configuration.username = idigi_username
      configuration.password = idigi_password
    end
  end
end
