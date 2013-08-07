module DeviceCloud
  class PushNotification::Alert < PushNotification::Base
    def handle!
      DeviceCloud.push_notification_alert_handler.call(self)
    end
  end
end