module DeviceCloud
  class DeviceDisconnectAlarm < Alarm
    attr_accessor :reconnectWindowDuration, :reset_on_reconnect, :device_id, :group
    attr_reader :group

    def group=(group_object)
      raise DeviceCloud::Error, 'Must be a DeviceCloud::Group' unless group_object.is_a?(DeviceCloud::Group)

      @group = group_object
      self.grpId = group.grpId
    end

    def initialize(attributes = {})
      super
      load_group
      load_device_id
      self.almtId = 2
    end

    def persist!
      raise DeviceCloud::Error, 'Must specify @group or @device_id.' unless group || device_id
      super
    end
  private
    def default_create_options
      {
        'reconnectWindowDuration' => '5',
        'reset_on_reconnect' => true
      }
    end

    def set_defaults
      super
      default_create_options.each do |k,v|
        send("#{k}=",v)
      end
    end

    def alarm_scope_config_xml
      return '' if group.nil? && device_id.nil?
      "<almScopeConfig><ScopingOptions>\n#{scope_xml}</ScopingOptions></almScopeConfig>\n"
    end

    def scope_xml
      group.nil? ? device_scope_xml : group_scope_xml
    end

    def group_scope_xml
      "<Scope name=\"Group\" value=\"#{group.grpPath}\" />"
    end

    def device_scope_xml
      "<Scope name=\"Device\" value=\"#{device_id}\" />"
    end

    def alarm_rule_config_xml
      xml = "<almRuleConfig><Rules>\n"
      xml << fire_rule_xml
      xml << reset_rule_xml
      xml << "</Rules></almRuleConfig>\n"
    end

    def reset_rule_xml
      xml = '<ResetRule name="resetRule1"'
      xml << ' enabled="false"' unless reset_on_reconnect
      xml << " />\n"
    end

    def fire_rule_xml
      xml = '<FireRule name="fireRule1">'
      xml << '<Variable name="reconnectWindowDuration" value="'
      xml << reconnectWindowDuration
      xml << "\" /></FireRule>\n"
    end

    def load_group
      return if almScopeConfig.nil? || almScopeConfig['ScopingOptions']['Scope']['@name'] != 'Group'
      @group ||= DeviceCloud::Group.find(grpId)
    end

    def load_device_id
      return if almScopeConfig.nil? || almScopeConfig['ScopingOptions']['Scope']['@name'] != 'Device'
      @device_id ||= almScopeConfig['ScopingOptions']['Scope']['@value']
    end
  end
end
