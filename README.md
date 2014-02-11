# DeviceCloud

[![Gem Version](https://badge.fury.io/rb/device_cloud.png)](http://badge.fury.io/rb/device_cloud)

[![wercker status](https://app.wercker.com/status/88a596a14228b6d5b8e7a57dd5d6db55/m/ "wercker status")](https://app.wercker.com/project/bykey/88a596a14228b6d5b8e7a57dd5d6db55)

TODO:
- remove any assumptions about Device Cloud FileData contents .. probably should only parse them if asked
- add code for maintaining monitors

## Installation

Add this line to your application's Gemfile:

    gem 'device_cloud'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install device_cloud

## Usage

TODO: Write usage instructions here

## Example Push Notification

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

That notification's unencoded fdData:

```json
{
  "value": {
    "plate": "941GVT",
    "confidence": "99",
    "country": "US",
    "towards_camera": "false",
    "timestamp": "2013-10-21T14:34:40Z",
    "overview_image_id": "lot_overview_cap_10_21_2013_143440.jpg",
    "state": "MN",
    "patch_image_id": "lot_patch_cap_10_21_2013_143440.jpg"
  },
  "class": "event",
  "queued_dt": "2013-10-21T19:34:56Z",
  "type": "parking_lot_event_exit",
  "id": "dd9d57363a8711e3a9bd0013950e6017",
  "device_id": "m:0013950E6017"
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
