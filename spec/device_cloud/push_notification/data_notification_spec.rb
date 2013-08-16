require 'spec_helper'

describe DeviceCloud::PushNotification::DataNotification do
  let(:raw_file_data) do
    {
      "id" => {
        "fdPath" => " /db/4044_MadGlory_Interactive/00000000-00000000-001395FF-FF0E6012/alert/",
        "fdName" => "foo-0966595cdcdd11e2abf50013950e6012.json"
      },
      "fdLastModifiedDate" => "2013-06-24T14:52:55.421Z",
      "fdSize" => 156,
      "fdContentType" => "application/json",
      "fdData" => "eyJ2YWx1ZSI6IHt9LCAiY2xhc3MiOiAiYWxlcnQiLCAicXVldWVkX2R0IjogIjIwMTMtMDYtMjRUMTQ6NDc6NDdaIiwgInR5cGUiOiAiZm9vIiwgImlkIjogIjA5NjY1OTVjZGNkZDExZTJhYmY1MDAxMzk1MGU2MDEyIiwgImRldmljZV9pZCI6ICJtOjAwMTM5NTBFNjAxMiJ9",
      "fdArchive" => false,
      "cstId" => 4044,
      "fdType" => "file",
      "fdCreatedDate" => "2013-06-24T14:52:55.421Z"
    }
  end

  let(:file_data) { DeviceCloud::PushNotification::Message::FileData.new raw_file_data }

  subject { DeviceCloud::PushNotification::DataNotification.new file_data }
  
  describe "#handle!" do

    it "should call the DeviceCloud.data_notification_handler with self" do
      handled_data = nil
      DeviceCloud.data_notification_handler = ->(data) { handled_data = data }

      subject.handle!
      expect(handled_data).to eq subject
    end
  end
end