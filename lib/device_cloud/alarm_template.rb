module DeviceCloud
  class AlarmTemplate

    attr_reader :almtId, :almtName, :almtDescription, :grpId, :almtTopic, :almtScopeOptions, :almtRules, :almtResourceList

    class << self
      def all
        templates = DeviceCloud::Request.new(path: '/ws/AlarmTemplate/.json').get.to_hash_from_json

        return [] unless templates['resultSize'].to_i > 0

        templates['items'].map { |template|
          AlarmTemplate.new template
        }
      end

      def find(id)
        templates = DeviceCloud::Request.new(path: "/ws/AlarmTemplate/#{id}.json").get.to_hash_from_json

        return nil unless templates['resultSize'].to_i > 0

        AlarmTemplate.new templates['items'].first
      end
    end

    def initialize(attributes = {})
      attributes.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end

  private
    def almtId=(value)
      @almtId = value.to_i
    end
  end
end
