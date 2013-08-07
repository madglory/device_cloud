require 'spec_helper'

describe DeviceCloud::PushNotification::Base do
  let(:data) do
    {
      'id' => {'fdPath' => '/some/place/','fdName' => 'file_name.json'},
      'device_id' => 'm:1392301029',
      'type' => 'some type',
      'queued_dt' => '2013-06-24T14:52:55.421Z',
      'value' => {'this' => 'is a value'}
    }
  end
  let(:file_data) { OpenStruct.new(data: data, full_path: '/foo/bar/baz.json') }

  subject { DeviceCloud::PushNotification::Base.new file_data }

  describe "attributes" do
    its(:id) { should eq data['id'] }
    its(:device_id) { should eq data['device_id'] }
    its(:type) { should eq data['type'] }
    its(:queued_at) { should eq data['queued_dt'] }
    its(:value) { should eq data['value'] }
  end

  describe "#handle!" do
    it "should raise NotImplementedError" do
      expect{subject.handle!}.to raise_error NotImplementedError
    end
  end

  describe "#mac_address" do
    context "when device_id present" do
      its(:mac_address) { should eq('13:92:30:10:29') }
    end

    context 'when device_id blank' do
      before(:each) do
        data['device_id'] = ''
      end

      its(:mac_address) { should eq '' }
    end
  end

  describe "#full_path" do
    context "when id present" do
      its(:full_path) { should eq(data['id']['fdPath'] + data['id']['fdName']) }
    end

    context 'when id not present' do
      before(:each) do
        data['id'] = ''
      end

      its(:full_path) { should eq '' }
    end
  end
end