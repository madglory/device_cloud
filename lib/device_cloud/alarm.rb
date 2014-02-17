module DeviceCloud
  class Alarm

    attr_accessor :almId, :cstId, :almtId, :grpId, :almName, :almDescription, :almScopeConfig, :almRuleConfig
    attr_reader :error, :almEnabled, :almPriority

    class << self
      def all
        response = DeviceCloud::Request.new(path: '/ws/Alarm').get
        alarms = response.to_hash_from_xml

        return [] unless response.code == '200' && alarms['result']['resultSize'].to_i > 0

        if alarms['result']['resultSize'].to_i == 1
          [initialize_proper_alarm_type(alarms['result']['Alarm'])]
        else
          alarms['result']['Alarm'].map { |alarm|
            initialize_proper_alarm_type(alarm)
          }
        end
      end

      def find(id)
        response = DeviceCloud::Request.new(path: "/ws/Alarm/#{id}").get
        alarms = response.to_hash_from_xml

        return nil unless response.code == '200' && alarms['result']['resultSize'].to_i > 0

        if alarms['result']['resultSize'].to_i == 1
          initialize_proper_alarm_type(alarms['result']['Alarm'])
        else
          initialize_proper_alarm_type(alarms['result']['Alarm'].first)
        end
      end

    protected
      def initialize_proper_alarm_type(alarm)
        case alarm['almtId']
        when '2' then DeviceDisconnectAlarm.new(alarm)
        else Alarm.new(alarm)
        end
      end
    end

    def initialize(attributes = {})
      set_defaults

      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def almEnabled=(value)
      @almEnabled = !!value
    end

    def almPriority=(value)
      raise DeviceCloud::Error, 'almPriority must be 0 (high), 1 (medium), or 2 (low)' unless [0,1,2].include?(value.to_i)
      @almPriority = value.to_i
    end

    def persist!
      remove_instance_variable '@error' if error
      almId.nil? ? create : update
    end

    def destroy!
      return false if almId.nil?

      response = DeviceCloud::Request.new(path: "/ws/Alarm/#{almId}").delete

      response.code == '200' ? true : false
    end

    def attributes
      available_attributes.inject({}) do |memo, attr_name|
        memo[attr_name] = send(attr_name) unless send(attr_name).nil?
        memo
      end
    end

  protected
    def set_defaults
      # no-op
    end

    def available_attributes
      %w{
        almtId
        almName
        almDescription
        almPriority
        almEnabled
        grpId
      }
    end

    def create
      response = DeviceCloud::Request.new(path: '/ws/Alarm', body: to_xml).post
      xml_result = response.to_hash_from_xml['result']

      if response.code == '201'
        self.almId = xml_result['location'].sub /Alarm\//, ''
        return true
      else
        @error = xml_result['error']
        return false
      end
    end

    def update
      response = DeviceCloud::Request.new(path: "/ws/Alarm/#{almId}", body: to_xml).put

      if response.code == '200'
        return true
      else
        @error = error_from_response_xml(response)
        return false
      end
    end

    def to_xml
      xml = '<Alarm>'
      attributes.each do |key,value|
        xml << "<#{key}>#{value}</#{key}>"
      end
      xml << alarm_scope_config_xml
      xml << alarm_rule_config_xml
      xml << '</Alarm>'
    end

    # Method to set the Alarm's scope
    #
    # Example:
    # <almScopeConfig>
    #     <ScopingOptions>
    #         <Scope name="Resource" value="Weather/USA/*/Minneapolis"/>
    #     </ScopingOptions>
    # </almScopeConfig>
    def alarm_scope_config_xml
      raise NotImplementedError
    end

    # Method to set the Alarm's rules
    #
    # Example:
    # <almRuleConfig>
    #     <Rules>
    #         <FireRule name="fireRule1">
    #             <Variable name="operator" value="&gt;"/>
    #             <Variable name="thresholdvalue" value="1"/>
    #             <Variable name="timeUnit" value="seconds"/>
    #             <Variable name="timeout" value="10"/>
    #             <Variable name="type" value="double"/>
    #         </FireRule>
    #         <ResetRule name="resetRule1">
    #             <Variable name="type" value="double"/>
    #             <Variable name="thresholdvalue" value="1"/>
    #             <Variable name="operator" value="&lt;="/>
    #             <Variable name="timeUnit" value="seconds"/>
    #             <Variable name="timeout" value="10"/>
    #         </ResetRule>
    #     </Rules>
    # </almRuleConfig>
    def alarm_rule_config_xml
      raise NotImplementedError
    end

    def error_from_response_xml(response)
      response.body.match(/<error>(.*)<\/error>/)[1]
    end
  end
end
