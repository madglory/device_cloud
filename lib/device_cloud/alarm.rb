module DeviceCloud
  class Alarm

    attr_accessor :almId, :cstId, :almtId, :grpId, :almName, :almDescription, :almEnabled, :almPriority, :almScopeConfig, :almRuleConfig
    attr_reader :error

    DEFAULT_CREATE_OPTIONS = {

    }

    class << self
      def all
        alarms = DeviceCloud::Request.new('/ws/Alarm/.json').get.to_hash_from_json

        return [] unless alarms['resultSize'].to_i > 0

        alarms['items'].map { |alarm|
          Alarm.new alarm
        }
      end

      def find(id)
        alarms = DeviceCloud::Request.new("/ws/Alarm/#{id}.json").get.to_hash_from_json

        return nil unless alarms['resultSize'].to_i > 0

        Alarm.new alarms['items'].first
      end
    end

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end

      @error = nil

      set_defaults
    end

    def persist!
      @error = nil
      almId.nil? ? create : update
    end

  private
    def set_defaults
      puts 'setting defaults...'
    end

    def create
      puts 'creating...'
    end

    def update
      puts 'updating... '
    end
  end
end
