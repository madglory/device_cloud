module DeviceCloud
  class PushNotification
    attr_reader :messages

    def initialize(raw_messages)
      @messages = DeviceCloud::PushNotification::Message.parse_raw_messages(raw_messages)
    end

    def handle_each!
      messages.each do |message|
        next unless message.valid? && message.valid_parsed_file_data?

        klass = class_type(message.topic_type)
        
        klass.handle!(message.parsed_file_data)
      end
    end
  private
    def class_type(class_name)
      DeviceCloud.constantize "DeviceCloud::PushNotification::#{class_name.capitalize}"
    end
  end
end