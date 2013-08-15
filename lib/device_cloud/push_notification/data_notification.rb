module DeviceCloud
  class PushNotification::DataNotification < PushNotification::BaseNotification
    def initialize(file_data)
      @file_data = file_data
      @id = data['id']
    end

    def file_name
      return '' unless id
      id['fdName']
    end

    def handle!
      DeviceCloud.data_notification_handler.call(self)
    end
  end
end