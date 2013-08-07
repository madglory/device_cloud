require 'spec_helper'

describe DeviceCloud::PushNotification::Base do
  let(:data) do
    {
      'id' => 1234,
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
end