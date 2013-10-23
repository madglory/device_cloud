module DeviceCloud
  class PushNotification::Message
    attr_accessor :timestamp, :topic, :file_data, :operation, :group, :replay

    KNOWN_TOPICS = %w{ event data alert }

    def self.parse_raw_messages(raw_message_data)
      if raw_message_data.is_a? Array
        messages = raw_message_data.map {|message| new(message) }
      else
        messages = [new(raw_message_data)]
      end
      messages
    end

    def initialize(attributes = {})
      attributes.each do |name, value|
        if name == 'FileData'
          @file_data = value
        else
          send("#{name}=", value)
        end
      end
      DeviceCloud.logger.info "DeviceCloud::PushNotification::Message Invalid (no FileData) - #{topic}" unless valid?
    end

    def topic_type
      topic_matches.first
    end

    def parsed_file_data
      return false unless valid?
      @parsed_file_data ||= FileData.new file_data
    end

    def no_content?
      parsed_file_data.no_content?
    end

    def valid?
      !!file_data
    end
  private
    def topic_matches
      topic.split('/') & KNOWN_TOPICS
    end
  end
end