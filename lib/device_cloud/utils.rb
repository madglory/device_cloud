module DeviceCloud
  module Utils
    def mac_address_from_device_id(device_id)
      device_id.sub(/\Am:/, '').scan(/.{2}|.+/).join(':')
    end

    def constantize(string)
      string.split("::").inject(Module) {|acc, val| acc.const_get(val)}
    end
  end
end