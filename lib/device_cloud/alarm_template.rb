module DeviceCloud
  class AlarmTemplate

    attr_reader :almtId, :almtName, :almtDescription, :grpId, :almtTopic, :almtScopeOptions, :almtRules, :almtResourceList

    class << self
      def all
        response = DeviceCloud::Request.new(path: '/ws/AlarmTemplate').get
        templates = response.to_hash_from_xml

        return [] unless response.code == '200' && templates['result']['resultSize'].to_i > 0

        if templates['result']['resultSize'].to_i == 1
          [AlarmTemplate.new(templates['result']['AlarmTemplate'])]
        else
          templates['result']['AlarmTemplate'].map { |template|
            AlarmTemplate.new template
          }
        end
      end

      def find(id)
        response = DeviceCloud::Request.new(path: "/ws/AlarmTemplate/#{id}").get
        templates = response.to_hash_from_xml

        return nil unless response.code == '200' && templates['result']['resultSize'].to_i == 1

        AlarmTemplate.new(templates['result']['AlarmTemplate'])
      end
    end

    def initialize(attributes = {})
      attributes.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end
  end
end
