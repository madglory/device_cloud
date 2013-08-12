module DeviceCloud
  class PushNotification::EventNotification < PushNotification::BaseNotification
    def handle!
      DeviceCloud.event_notification_handler.call(self)
    end
  end
end