module DeviceCloud
  class PushNotification::Message
    attr_accessor :timestamp, :topic, :file_data, :operation, :group, :replay

    ALLOWED_TOPICS = %w{alert event}

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
      DeviceCloud.logger.warn "DeviceCloud::PushNotification::Message Invalid (no content) - #{topic}" unless valid?
    end

    def parsed_file_data
      return false unless valid?
      @parsed_file_data ||= FileData.new file_data
    end

    def valid?
      !!file_data && topic_allowed?
    end

    def valid_parsed_file_data?
      parsed_file_data.valid?
    end

    def topic_type
      topic_matches.first
    end

  private
    def topic_allowed?
      return false if !topic
      topic_matches.any?
    end

    def topic_matches
      topic.split('/') & ALLOWED_TOPICS
    end
  end
end