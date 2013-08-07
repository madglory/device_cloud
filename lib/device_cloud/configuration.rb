module DeviceCloud
  module Configuration

    # DeviceCloud root_url
    attr_writer :root_url

    # DeviceCloud username
    attr_writer :username

    # DeviceCloud password
    attr_writer :password

    # Proc that will be called for handling
    # DeviceCloud::PushNotification::Event objects
    # Proc will be called with the event object
    attr_accessor :push_notification_event_handler

    # Proc that will be called for handling
    # DeviceCloud::PushNotification::Alert objects
    # Proc will be called with the alert object
    attr_accessor :push_notification_alert_handler

    # Yield self to be able to configure ActivityFeed with
    # block-style configuration.
    #
    # Example:
    #
    #   ActivityFeed.configure do |configuration|
    #     configuration.root_url = 'https://example.com'
    #   end
    def configure
      yield self
    end

    # DeviceCloud url
    #
    # @return the DeviceCloud url or the default of 'https://my.idigi.com' if not set.
    def root_url
      @root_url ||= 'https://my.idigi.com'
    end

    # DeviceCloud username
    #
    # @return the DeviceCloud username or raises an error
    def username
      raise 'DeviceCloud username is blank' if @username.blank?
      @username
    end

    # DeviceCloud password
    #
    # @return the DeviceCloud password or raises an error
    def password
      raise 'DeviceCloud password is blank' if @password.blank?
      @root_url
    end
  end
end