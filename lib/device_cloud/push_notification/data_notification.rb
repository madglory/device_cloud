module DeviceCloud
  class PushNotification::DataNotification < PushNotification::BaseNotification
    def handle!
      DeviceCloud.data_notification_handler.call(self)
    end
  end
end