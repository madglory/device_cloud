module DeviceCloud
  class PushNotification::DataNotification < PushNotification::BaseNotification
    def initialize(file_data)
      @file_data = file_data
    end

    def handle!
      DeviceCloud.data_notification_handler.call(self)
    end
  end
end