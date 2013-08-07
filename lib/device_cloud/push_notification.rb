module DeviceCloud
  class PushNotification
    attr_reader :messages

    def initialize(raw_messages)
      @messages = DeviceCloud::PushNotification::Message.parse_raw_messages(raw_messages)
    end

    def enqueue_all!
      messages.each do |message|
        next unless message.valid? && message.parsed_file_data.valid?

        klass = class_type(message.topic_type)
        
        klass.enqueue!(message.parsed_file_data)
      end
    end
  private
    def class_type(class_name)
      "DeviceCloud::PushNotification::#{class_name.capitalize}".constantize
    end
  end
end