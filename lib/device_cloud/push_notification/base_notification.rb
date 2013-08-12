module DeviceCloud
  class PushNotification::BaseNotification
    attr_reader :id, :full_path, :device_id, :value, :queued_at, :type
    
    def self.handle!(file_data)
      event = new(file_data)
      event.handle!
    end

    def initialize(file_data)
      @file_data = file_data
      @id = data["id"]
      @full_path = file_data.full_path
      @device_id = data["device_id"]
      @type = data["type"]
      @queued_at = data["queued_dt"]
      @value = data["value"]
    end

    def handle!
      raise NotImplementedError
    end

    def mac_address
      return '' unless device_id.size > 0
      device_id.sub(/\Am:/, '').scan(/.{2}|.+/).join(':')
    end

    def data
      @file_data.data
    end
  end
end