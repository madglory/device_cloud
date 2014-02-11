module DeviceCloud
  class PushNotification
    attr_reader :messages

    def initialize(response_body)
      @messages = DeviceCloud::PushNotification::Message.parse_raw_messages(response_body)
    end

    def handle_each!
      messages.each do |message|
        next unless message.valid?

        klass = class_type(message.topic_type)

        message.no_content? ? klass.handle_no_content!(message.parsed_file_data) : klass.handle!(message.parsed_file_data)
      end
    end
  private
    def class_type(class_name)
      DeviceCloud.constantize "DeviceCloud::PushNotification::#{class_name.capitalize}Notification"
    end
  end
end
