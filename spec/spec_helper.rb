require 'device_cloud'
require 'ostruct'

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:each) do
    DeviceCloud.configure do |configuration|
      configuration.username = 'a username'
      configuration.password = 'a password'
    end
  end
end