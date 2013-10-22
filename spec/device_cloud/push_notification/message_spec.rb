require 'spec_helper'

describe DeviceCloud::PushNotification::Message do
  let(:single_raw_message) do
    {
      "timestamp" => "2013-06-24T14:52:55.427Z",
      "topic" => "4044/FileData/db/4044_MadGlory_Interactive/00000000-00000000-001395FF-FF0E6012/alert/foo-0966595cdcdd11e2abf50013950e6012.json",
      "FileData" => {
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
      },
      "operation" => "INSERTION",
      "replay" => true,
      "group" => "*"
    }
  end

  let(:multiple_raw_messages) do
    [
      {
        "timestamp" => "2013-06-24T14:52:55.427Z",
        "topic" => "4044/FileData/db/4044_MadGlory_Interactive/00000000-00000000-001395FF-FF0E6012/alert/foo-0966595cdcdd11e2abf50013950e6012.json",
        "FileData" => {
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
        },
        "operation" => "INSERTION",
        "replay" => true,
        "group" => "*"
      },
      {
        "timestamp" => "2013-06-24T14:52:55.427Z",
        "topic" => "4044/FileData/db/4044_MadGlory_Interactive/00000000-00000000-001395FF-FF0E6012/alert/foo-0966595cdcdd11e2abf50013950e6012.json",
        "FileData" => {
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
        },
        "operation" => "INSERTION",
        "replay" => true,
        "group" => "*"
      }
    ]
  end

  describe "#parse_raw_messages" do
    context "single message" do
      it "should return an array" do
        expect(DeviceCloud::PushNotification::Message.parse_raw_messages(single_raw_message).class).to eq(Array)
      end

      it "array objects should be of class DeviceCloud::PushNotification::Message" do
        expect(DeviceCloud::PushNotification::Message.parse_raw_messages(single_raw_message).first.class).to eq(DeviceCloud::PushNotification::Message)
      end

      it "should return an array with a single item" do
        expect(DeviceCloud::PushNotification::Message.parse_raw_messages(single_raw_message).size).to eq(1)
      end
    end

    context "multiple messages" do
      it "should return an array" do
        expect(DeviceCloud::PushNotification::Message.parse_raw_messages(multiple_raw_messages).class).to eq(Array)
      end

      it "array objects should be of class DeviceCloud::PushNotification::Message" do
        DeviceCloud::PushNotification::Message.parse_raw_messages(multiple_raw_messages).each do |item|
          expect(item.class).to eq(DeviceCloud::PushNotification::Message)
        end
      end

      it "should return an array with the same amount of items it was passed" do
        expect(DeviceCloud::PushNotification::Message.parse_raw_messages(multiple_raw_messages).size).to eq(multiple_raw_messages.size)
      end
    end

    describe "#valid?" do
      context "with file_data" do
        subject { DeviceCloud::PushNotification::Message.new 'FileData' => 'present' }
        its(:valid?) { should be_true }
      end

      context "without file_data" do
        let(:logger) { double('logger') }
        before(:each) do
          DeviceCloud.logger = logger
          logger.should_receive(:info)
        end

        after(:each) do
          DeviceCloud.logger = Logger.new(STDOUT)
        end

        subject { DeviceCloud::PushNotification::Message.new }
        its(:valid?) { should_not be_true }
      end
    end

    describe "#parsed_file_data" do
      context "when invalid" do
        let(:logger) { double('logger') }
        before(:each) do
          DeviceCloud.logger = logger
          logger.should_receive(:info)
        end

        after(:each) do
          DeviceCloud.logger = Logger.new(STDOUT)
        end
        it "should be false" do
          expect(subject.parsed_file_data).to be_false
        end
      end

      context "when valid" do
        subject { DeviceCloud::PushNotification::Message.new 'FileData' => single_raw_message["FileData"] }

        it "should return a DeviceCloud::PushNotification::Message::FileData object" do
          expect(subject.parsed_file_data.class).to eq(DeviceCloud::PushNotification::Message::FileData)
        end

        it "should cache the FileData object" do
          file_data1 = subject.parsed_file_data
          subject.parsed_file_data.should === file_data1
        end
      end
    end
  end
end