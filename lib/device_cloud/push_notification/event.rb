module DeviceCloud
  class PushNotification::Event < PushNotification::Base
    def handle!
      DeviceCloud.push_notification_event_handler.call(self)
    end
  end
end