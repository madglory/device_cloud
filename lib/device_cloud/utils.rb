module DeviceCloud
  module Utils
    def constantize(string)
      string.split("::").inject(Module) {|acc, val| acc.const_get(val)}
    end
  end
end