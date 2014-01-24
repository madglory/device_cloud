# DeviceCloud

#####TODO:

* Add code for maintaining monitors
* Add code for maintaining devices

## Installation
Add this line to your application's Gemfile:

    gem 'device_cloud'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install device_cloud

## Usage

### Configuration

    DeviceCloud.configure do |config|
      config.root_url = 'https://my.idigi.com' # default
      config.username
      config.password
    end


### Handling Push Notifications

When your application receives a push notification it can be passed to the DeviceCloud gem using the following:

    push_notification = DeviceCloud::PushNotification(json['Document']['Msg'])
    push_notification.handle_each!

The event will then be handled by one of your defined Notification Handlers.

### Notification Handlers

Notification handlers take a Proc, and are called with a relevant alert or event object. A list of supported topic handlers are listed as follows:

    alert_notification_handler
    data_notification_handler
    event_notification_handler

The following empty notification handlers are also available:

    empty_alert_notification_handler
    empty_data_notification_handler
    empty_event_notification_handler

An example definition may look like the following

    DeviceCloud.alert_notification_handler do |alert|
       puts "#{alert.type} Alert: for device #{alert.device_id}
       puts "Base 64 encoded data #{alert.raw_data}"
    end


### Example Push Notification


```json
{
  "Document": {
    "Msg": {
      "timestamp": "2013-10-21T19:34:56Z",
      "topic": "device/event/event.json",
      "FileData": {
        "id": {
          "fdPath": "/device/event/",
          "fdName": "event.json"
        },
        "fdLastModifiedDate": "2013-10-21T19:34:56Z",
        "fdSize": 545,
        "fdContentType": "application/json",
        "fdData": "eW91IGhhdmUgdG9vIG11Y2ggZnJlZSB0aW1l\n",
        "fdArchive": false,
        "cstId": 4044,
        "fdType": "event",
        "fdCreatedDate": "2013-06-24T14:52:55.421Z"
      },
      "operation": "INSERTION",
      "replay": true,
      "group": "*"
    }
  }
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
