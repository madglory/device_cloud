module DeviceCloud
  class PushNotification::Base
    attr_reader :id, :device_id, :value, :queued_at, :type
    
    def self.handle!(file_data)
      event = new(file_data)
      event.handle!
    end

    def initialize(file_data)
      @file_data = file_data
      @id = data["id"]
      @device_id = data["device_id"]
      @type = data["type"]
      @queued_at = data["queued_dt"]
      @value = data["value"]
    end

    def handle!
      raise NotImplementedError
    end

    def data
      @file_data.data
    end
  end
end