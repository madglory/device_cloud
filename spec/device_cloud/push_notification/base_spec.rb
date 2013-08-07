require 'spec_helper'

describe DeviceCloud::PushNotification::Base do
  let(:data) do
    {
      'id' => '1234',
      'device_id' => 'm:1392301029',
      'type' => 'some type',
      'queued_dt' => '2013-06-24T14:52:55.421Z',
      'value' => {'this' => 'is a value'}
    }
  end
  let(:file_data) do
    OpenStruct.new(
      full_path: '/some/place/file_name.json',
      data: data,
      full_path: '/foo/bar/baz.json'
    )
  end

  subject { DeviceCloud::PushNotification::Base.new file_data }

  describe "attributes" do
    its(:id) { should eq data['id'] }
    its(:full_path) { should eq file_data.full_path }
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
end