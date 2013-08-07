module DeviceCloud
  class PushNotification::Alert
    attr_reader :id, :device_id, :value, :queued_at, :type

    def self.handle!(file_data)
      alert = new(file_data)
      alert.handle!
    end

    def initialize(file_data)
      @file_data = file_data
      @id = data["id"]
      @device_id = data["device_id"]
      @type = data["type"]
      @queued_at = DateTime.parse data["queued_dt"]
      @value = data["value"]
    end

    def handle!
      DeviceCloud.push_notification_alert_handler.call(self)
    end
  end
end