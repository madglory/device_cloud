# DeviceCloud

#####TODO:

* Add code for maintaining monitors

## Installation

    DeviceCloud.configure do |config|
      config.root_url = 'https://my.idigi.com' # default
      config.username
      config.password
    end

Add this line to your application's Gemfile:

    gem 'device_cloud'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install device_cloud

## Usage

### Configuration

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
      "topic": "4044/FileData/db/4044_MadGlory_Interactive/00000000-00000000-001395FF-FF0E6017/event/parking_lot_event_exit-0966595cdcdd11e2abf50013950e6017.json",
      "FileData": {
        "id": {
          "fdPath": "/db/4044_MadGlory_Interactive/00000000-00000000-001395FF-FF0E6017/event/",
          "fdName": "parking_lot_event_exit-0966595cdcdd11e2abf50013950e6017.json"
        },
        "fdLastModifiedDate": "2013-10-21T19:34:56Z",
        "fdSize": 545,
        "fdContentType": "application/json",
        "fdData": "eyJ2YWx1ZSI6eyJwbGF0ZSI6Ijk0MUdWVCIsImNvbmZpZGVuY2UiOiI5OSIsImNvdW50cnkiOiJVUyIsInRvd2FyZHNfY2FtZXJhIjoiZmFsc2UiLCJ0aW1lc3RhbXAiOiIyMDEzLTEwLTIxVDE0OjM0OjQwWiIsIm92ZXJ2aWV3X2ltYWdlX2lkIjoibG90X292ZXJ2aWV3X2NhcF8xMF8yMV8yMDEzXzE0MzQ0MC5qcGciLCJzdGF0ZSI6Ik1OIiwicGF0Y2hfaW1hZ2VfaWQiOiJsb3RfcGF0Y2hfY2FwXzEwXzIxXzIwMTNfMTQzNDQwLmpwZyJ9LCJjbGFzcyI6ImV2ZW50IiwicXVldWVkX2R0IjoiMjAxMy0xMC0yMVQxOTozNDo1NloiLCJ0eXBlIjoicGFya2luZ19sb3RfZXZlbnRfZXhpdCIsImlkIjoiZGQ5ZDU3MzYzYTg3MTFlM2E5YmQwMDEzOTUwZTYwMTciLCJkZXZpY2VfaWQiOiJtOjAwMTM5NTBFNjAxNyJ9",
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
