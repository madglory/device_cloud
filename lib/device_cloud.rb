require 'device_cloud/configuration'
require 'device_cloud/utils'
require 'device_cloud/version'
require 'device_cloud/alarm'
require 'device_cloud/device_disconnect_alarm'
require 'device_cloud/alarm_template'
require 'device_cloud/group'
require 'device_cloud/monitor'
require 'device_cloud/push_notification'
require 'device_cloud/push_notification/base_notification'
require 'device_cloud/push_notification/alert_notification'
require 'device_cloud/push_notification/event_notification'
require 'device_cloud/push_notification/data_notification'
require 'device_cloud/push_notification/message'
require 'device_cloud/push_notification/message/file_data'
require 'device_cloud/request'
require 'device_cloud/response'
require 'nori'

module DeviceCloud
  extend Configuration
  extend Utils
  class Error < StandardError; end
end
