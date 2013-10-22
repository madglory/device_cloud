require 'spec_helper'

describe DeviceCloud::PushNotification::BaseNotification do
  let(:data_string) { "{\"value\": {}, \"class\": \"alert\", \"queued_dt\": \"2013-06-24T14:47:47Z\", \"type\": \"foo\", \"id\": \"0966595cdcdd11e2abf50013950e6012\", \"device_id\": \"m:0013950E6012\"}" }
  let(:raw_file_data) do
    {
      "id" => {
        "fdPath" => "/db/4044_MadGlory_Interactive/00000000-00000000-001395FF-FF0E6012/alert/",
        "fdName" => "foo-0966595cdcdd11e2abf50013950e6012.json"
      },
      "fdLastModifiedDate" => "2013-06-24T14:52:55.421Z",
      "fdSize" => 156,
      "fdContentType" => "application/json",
      "fdData" => Base64.encode64(data_string),
      "fdArchive" => false,
      "cstId" => 4044,
      "fdType" => "file",
      "fdCreatedDate" => "2013-06-24T14:52:55.421Z"
    }
  end

  let(:file_data) { DeviceCloud::PushNotification::Message::FileData.new raw_file_data }

  subject { DeviceCloud::PushNotification::BaseNotification.new file_data }

  describe "attributes" do
    its(:id) { should eq file_data.data['id'] }
    its(:full_path) { should eq(raw_file_data['id']['fdPath'] + raw_file_data['id']['fdName']) }
    its(:device_id) { should eq file_data.data['device_id'] }
    its(:type) { should eq file_data.data['type'] }
    its(:queued_at) { should eq file_data.data['queued_dt'] }
    its(:value) { should eq file_data.data['value'] }
  end

  describe "#data" do
    its(:data) { should eq file_data.data }
  end

  describe "#handle!" do
    it "should raise NotImplementedError" do
      expect{subject.handle!}.to raise_error NotImplementedError
    end
  end

  describe "#handle_no_content!" do
    let(:logger) { double('logger') }
    before(:each) do
      DeviceCloud.logger = logger
    end

    after(:each) do
      DeviceCloud.logger = Logger.new(STDOUT)
    end

    it "should raise NotImplementedError" do
      logger.should_receive(:info).with("DeviceCloud::PushNotification::BaseNotification - No FileData content - NotImplemented #{raw_file_data['id']['fdPath']}#{raw_file_data['id']['fdName']}")
      subject.handle_no_content!
    end
  end

  describe "#mac_address" do
    context "when device_id present" do
      its(:mac_address) { should eq('00:13:95:0E:60:12') }
    end

    context 'when device_id blank' do
      let(:data_string) { "{\"value\": {}, \"class\": \"alert\", \"queued_dt\": \"2013-06-24T14:47:47Z\", \"type\": \"foo\", \"id\": \"0966595cdcdd11e2abf50013950e6012\", \"device_id\": \"\"}" }

      its(:mac_address) { should eq '' }
    end

    context "when device_id is not present" do
      let(:data_string) { "{\"value\": {}, \"class\": \"alert\", \"queued_dt\": \"2013-06-24T14:47:47Z\", \"type\": \"foo\", \"id\": \"0966595cdcdd11e2abf50013950e6012\"}" }

      its(:mac_address) { should eq '' }
    end
  end

  describe "#file_name" do
    its(:file_name) { should eq file_data.file_name}
  end

  describe "#raw_data" do
    its(:raw_data) { should eq raw_file_data['fdData'] }
  end
end