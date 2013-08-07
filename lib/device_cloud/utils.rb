module DeviceCloud
  module Utils
    def mac_address_from_device_id(device_id)
      device_id.sub(/\Am:/, '').scan(/.{2}|.+/).join(':')
    end
  end
end