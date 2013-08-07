require 'device_cloud/configuration'
require 'device_cloud/utils'
require 'device_cloud/version'
require 'device_cloud/push_notification'
require 'device_cloud/push_notification/base'
require 'device_cloud/push_notification/alert'
require 'device_cloud/push_notification/event'
require 'device_cloud/push_notification/message'
require 'device_cloud/push_notification/message/file_data'

module DeviceCloud
  extend Configuration
  extend Utils
end