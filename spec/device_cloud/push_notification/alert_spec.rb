require 'spec_helper'

describe DeviceCloud::PushNotification::Alert do
  let(:sentry_alert_type) { create(:sentry_alert_type) }
  let(:data) do
    {
      'id' => 1234,
      'device_id' => 'm:1392301029',
      'type' => sentry_alert_type.name,
      'queued_dt' => '2013-06-24T14:52:55.421Z',
      'value' => {'this' => 'is a value'}
    }
  end
  let(:file_data) { OpenStruct.new(data: data, full_path: '/foo/bar/baz.json') }
  let(:meter_group) { create(:meter_group, phone_numbers: '5555555555,333-333-3333') }
  let(:meter) { create(:meter, meter_group: meter_group, mac_address: '13:92:30:10:29') }

  subject { DeviceCloud::PushNotification::Alert.new file_data }

  describe "attributes" do
    its(:id) { should eq data['id'] }
    its(:device_id) { should eq data['device_id'] }
    its(:type) { should eq data['type'] }
    its(:queued_at) { should eq data['queued_dt'] }
    its(:value) { should eq data['value'] }
  end

  describe "#enqueue!" do
    before(:each) do
      DatabaseCleaner.clean
      meter # needs to exist
      sentry_alert_type # needs to exist
    end

    context "previously parsed alert" do
      it "should not create a new SentryAlert" do
        SentryAlert.create! device_cloud_path: file_data.full_path, meter: meter, sentry_alert_type: sentry_alert_type
        expect{subject.enqueue!}.to change(SentryAlert, :count).by(0)
      end
    end

    context "new alert" do
      it "should create a new SentryAlert" do
        expect{subject.enqueue!}.to change(SentryAlert, :count).by(1)
      end
    end

    context "for a known meter" do
      it "should not raise an AlertError" do
        expect{subject.enqueue!}.to_not raise_error
      end
    end

    context "for an unknown meter" do
      before(:each) do
        Meter.stub(:find_by_lowercase_mac).and_return([])
      end

      context "with no default group" do

        it "should raise an Error" do
          expect {
            subject.enqueue!
          }.to raise_error(DeviceCloud::PushNotification::MessageDocument::MessageDocumentError, "Unknown meter (13:92:30:10:29): #{file_data.full_path}")
        end
      end

      context "with default group" do
        let(:device) { double() }
        let(:meter) { Meter.new }

        before(:each) do
          muni = FactoryGirl.create(:municipality, name: "Etherios")
          @group = FactoryGirl.create(:meter_group, name: "Unknown Devices", municipality: muni)
        end

        it "should create a new meter on the fly" do
          DeviceCloud::Device.should_receive(:from_remote)
            .with(mac: "13:92:30:10:29").and_return(device)

          device.should_receive(:provision).with(@group).and_return(meter)

          SentryAlert.any_instance.should_receive(:save!).and_return(true)
          subject.enqueue!
        end
      end
    end

    context "for an unknown SentryAlertType" do
      it "should raise an AlertError" do
        SentryAlertType.should_receive(:where).with("lower(name) = ?", data['type']).and_return([])
        expect{subject.enqueue!}.to raise_error(DeviceCloud::PushNotification::Alert::AlertError, "Unknown alert type (#{data['type']}): #{file_data.full_path}")
      end
    end

    context "for a known SentryAlertType" do
      it "should not raise an AlertError" do
        expect{subject.enqueue!}.to_not raise_error 
      end
    end
  end
end