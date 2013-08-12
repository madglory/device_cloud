module DeviceCloud
  class PushNotification::AlertNotification < PushNotification::BaseNotification
    def handle!
      DeviceCloud.alert_notification_handler.call(self)
    end
  end
end