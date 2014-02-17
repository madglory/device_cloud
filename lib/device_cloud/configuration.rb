require 'logger'

module DeviceCloud
  module Configuration

    # DeviceCloud account username
    attr_writer :username

    # DeviceCloud account password
    attr_writer :password

    # DeviceCloud defualt logger
    attr_writer :logger

    # Proc that will be called for handling
    # DeviceCloud::PushNotification::EventNotification objects
    # Proc will be called with the event notification object
    attr_accessor :event_notification_handler

    # Proc that will be called for handling
    # DeviceCloud::PushNotification::EventNotification objects that
    # do not contain file data (data too large - over 120KB)
    # Proc will be called with the event notification object
    attr_accessor :empty_event_notification_handler

    # Proc that will be called for handling
    # DeviceCloud::PushNotification::AlertNotification objects
    # Proc will be called with the alert notification object
    attr_accessor :alert_notification_handler

    # Proc that will be called for handling
    # DeviceCloud::PushNotification::AlertNotification objects that
    # do not contain file data (data too large - over 120KB)
    # Proc will be called with the alert notification object
    attr_accessor :empty_alert_notification_handler

    # Proc that will be called for handling
    # DeviceCloud::PushNotification::DataNotification objects
    # Proc will be called with the data notification object
    attr_accessor :data_notification_handler

    # Proc that will be called for handling
    # DeviceCloud::PushNotification::DataNotification objects that
    # do not contain file data (data too large - over 120KB)
    # Proc will be called with the data notification object
    attr_accessor :empty_data_notification_handler

    # Yield self to be able to configure ActivityFeed with
    # block-style configuration.
    #
    # Example:
    #
    #   DeviceCloud.configure do |configuration|
    #     configuration.root_url = 'https://example.com'
    #   end
    def configure
      yield self
      config
    end

    def config
      {
        username: username,
        password: password,
        root_url: root_url,
        host: host,
        alert_notification_handler: @alert_notification_handler,
        empty_alert_notification_handler: @empty_alert_notification_handler,
        data_notification_handler: @data_notification_handler,
        empty_data_notification_handler: @empty_data_notification_handler,
        event_notification_handler: @event_notification_handler,
        empty_event_notification_handler: @empty_event_notification_handler,
        logger: logger
      }.freeze
    end

    # DeviceCloud url
    #
    # @return the DeviceCloud url - 'https://my.idigi.com'
    def root_url
      'https://my.idigi.com'
    end

    # DeviceCloud url
    #
    # @return the DeviceCloud host - 'my.idigi.com'
    def host
      'my.idigi.com'
    end

    # DeviceCloud username
    #
    # @return the DeviceCloud username or raises an error
    def username
      raise 'DeviceCloud username is blank' if @username.nil? || @password == ''
      @username
    end

    # DeviceCloud password
    #
    # @return the DeviceCloud password or raises an error
    def password
      raise 'DeviceCloud password is blank' if @password.nil? || @password == ''
      @password
    end

    # DeviceCloud logger
    #
    # @return the DeviceCloud logger or set the default to stdout
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    # DeviceCloud logger
    #
    # @return the DeviceCloud logger or set the default to stdout
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    # DeviceCloud xml_parser
    #
    # @return the DeviceCloud xml_parser - default is Nori using rexml
    def xml_parser
      Nori.new(parser: :rexml)
    end
  end
end
