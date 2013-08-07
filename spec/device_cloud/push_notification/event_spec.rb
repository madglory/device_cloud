require 'spec_helper'

describe DeviceCloud::PushNotification::Event do
  let(:data) do
    {
      'id' => 1234,
      'device_id' => 'm:1392301029',
      'type' => DeviceCloud::PushNotification::Event::PROCESSABLE_EVENTS.sample,
      'queued_dt' => '2013-06-24T14:52:55.421Z',
      'value' => {'this' => 'is a value'}
    }
  end
  let(:file_data) { OpenStruct.new(data: data, full_path: '/foo/bar/baz.json') }
  let(:meter) { create(:meter, mac_address: '13:92:30:10:29') }

  subject { DeviceCloud::PushNotification::Event.new file_data }

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
      meter
    end

    after(:each) do
      ParkingEventWorker.jobs.clear
    end

    it "should enqueue a ParkingEventWorker" do
      expect(ParkingEventWorker.jobs.size).to eq 0
      subject.enqueue!
      expect(ParkingEventWorker.jobs.size).to eq 1
    end

    it 'should give the right args to ParkingEventWorker' do
      subject.enqueue!
      expect(ParkingEventWorker.jobs[0]['args']).to eq [meter.id, data['value']]
    end
  end
end