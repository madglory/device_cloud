require 'spec_helper'

describe DeviceCloud::PushNotification do
  let(:raw_messages) do
    [
      { 'topic_type' => 'an alert' },
      { 'topic_type' => 'an event' },
      { 'topic_type' => 'a piece of data' }
    ]
  end
  let(:valid_parsed_messages) do
    [
      OpenStruct.new(
        valid?: true,
        valid_parsed_file_data?: true,
        topic_type: 'alert',
        parsed_file_data: 'the alert data'
      ),
      OpenStruct.new(
        valid?: true,
        valid_parsed_file_data?: true,
        topic_type: 'event',
        parsed_file_data: 'the event data'
      ),
      OpenStruct.new(
        valid?: true,
        valid_parsed_file_data?: true,
        topic_type: 'data',
        parsed_file_data: 'the data data'
      )
    ]
  end

  subject { DeviceCloud::PushNotification.new raw_messages }

  describe "attributes" do
    before(:each) do
      DeviceCloud::PushNotification::Message.should_receive(:parse_raw_messages).with(raw_messages).and_return(valid_parsed_messages)
    end
    its(:messages) { should eq valid_parsed_messages }
  end

  describe "#handle_each!" do
    before(:each) do
      DeviceCloud::PushNotification::Message.should_receive(:parse_raw_messages).with(raw_messages).and_return(valid_parsed_messages)
    end
    
    context "all valid" do

      it "should call handle! on each of the message's topic_type classes" do
        DeviceCloud::PushNotification::AlertNotification.should_receive(:handle!).with(valid_parsed_messages[0].parsed_file_data)

        DeviceCloud::PushNotification::EventNotification.should_receive(:handle!).with(valid_parsed_messages[1].parsed_file_data)

        DeviceCloud::PushNotification::DataNotification.should_receive(:handle!).with(valid_parsed_messages[2].parsed_file_data)

        subject.handle_each!

      end
    end

    context "an invalid message" do
      it "should not be handled" do
        valid_parsed_messages[0] = OpenStruct.new(
          valid?: false, # test condition
          valid_parsed_file_data?: true,
          topic_type: 'alert',
          parsed_file_data: 'the alert data'
        )

        DeviceCloud::PushNotification::AlertNotification.should_not_receive(:handle!)

        DeviceCloud::PushNotification::EventNotification.should_receive(:handle!)
        DeviceCloud::PushNotification::DataNotification.should_receive(:handle!)

        subject.handle_each!
      end
    end

    context "an invalid parsed_file_data" do
      it "should not be handled" do
        valid_parsed_messages[0] = OpenStruct.new(
          valid?: true,
          valid_parsed_file_data?: false, # test condition
          topic_type: 'alert',
          parsed_file_data: 'the alert data'
        )

        DeviceCloud::PushNotification::AlertNotification.should_not_receive(:handle!)

        DeviceCloud::PushNotification::EventNotification.should_receive(:handle!)
        DeviceCloud::PushNotification::DataNotification.should_receive(:handle!)

        subject.handle_each!
      end
    end
  end
end