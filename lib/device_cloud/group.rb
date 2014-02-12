module DeviceCloud
  class Group
    attr_reader :grpId, :grpName, :grpDescription, :grpPath, :grpParentId

    ALLOWED_ATTRIBUTES = %w{
      grpId
      grpName
      grpDescription
      grpPath
      grpParentId
    }

    class << self
      def all
        groups = DeviceCloud::Request.new(path: '/ws/Group/.json').get.to_hash_from_json

        return [] unless groups['resultSize'].to_i > 0

        groups['items'].map { |group|
          Group.new group
        }
      end

      def find(group_id)
        groups = DeviceCloud::Request.new(path: "/ws/Group/#{group_id}.json").get.to_hash_from_json

        return nil unless groups['resultSize'].to_i > 0

        Group.new groups['items'].first
      end
    end

    def initialize(attributes = {})
      ALLOWED_ATTRIBUTES.each do |attr_name|
        instance_variable_set("@#{attr_name}", attributes[attr_name])
      end
    end
  end
end
