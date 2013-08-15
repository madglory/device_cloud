module DeviceCloud
  class PushNotification::DataNotification < PushNotification::BaseNotification

    def raw_data
      @file_data.fdData
    end

    def handle!
      DeviceCloud.data_notification_handler.call(self)
    end
  end
end