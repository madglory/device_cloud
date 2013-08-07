require 'spec_helper'

describe DeviceCloud::PushNotification::Message::FileData do
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

  describe "attributes" do
    subject { DeviceCloud::PushNotification::Message::FileData.new raw_file_data }

    its(:id) { should eq(raw_file_data['id']) }
    its(:fdLastModifiedDate) { should eq(raw_file_data['fdLastModifiedDate']) }
    its(:fdSize) { should eq(raw_file_data['fdSize']) }
    its(:fdArchive) { should eq(raw_file_data['fdArchive']) }
    its(:cstId) { should eq(raw_file_data['cstId']) }
    its(:fdType) { should eq(raw_file_data['fdType']) }
    its(:fdCreatedDate) { should eq(raw_file_data['fdCreatedDate']) }
    its(:fdData) { should eq(raw_file_data["fdData"]) }
  end

  describe '#valid?' do
    subject { DeviceCloud::PushNotification::Message::FileData.new }
    context 'wrong file type' do
      let(:raw_file_data) do
        {
          "id" => {
            "fdPath" => "/db/4044_MadGlory_Interactive/00000000-00000000-001395FF-FF0E6014/",
            "fdName" => "event"
          },
          "fdLastModifiedDate" => "2013-06-26T16:18:39.675Z",
          "fdSize" => 0,
          "fdContentType" => "application/octet-stream",
          "fdArchive" => false,
          "cstId" => 4044,
          "fdType" => "directory",
          "fdCreatedDate" => "2013-06-26T16:18:39.675Z"
        }
      end

      subject { DeviceCloud::PushNotification::Message::FileData.new raw_file_data}
      its(:valid?) { should be_false }
      it "should set a 'wrong file type' error" do
        subject.valid?
        expect(subject.errors.include?('wrong file type')).to be_true
      end
    end

    context 'without content' do
      let(:raw_file_data) do
        {
          "id" => {
            "fdPath" => " /db/4044_MadGlory_Interactive/00000000-00000000-001395FF-FF0E6012/alert/",
            "fdName" => "foo-0966595cdcdd11e2abf50013950e6012.json"
          },
          "fdLastModifiedDate" => "2013-06-24T14:52:55.421Z",
          "fdSize" => 156,
          "fdContentType" => "application/octet-stream",
          "fdData" => "",
          "fdArchive" => false,
          "cstId" => 4044,
          "fdType" => "file",
          "fdCreatedDate" => "2013-06-24T14:52:55.421Z"
        }
      end

      subject { DeviceCloud::PushNotification::Message::FileData.new raw_file_data}
      its(:valid?) { should be_false }
      it "should set a 'wrong file type' error" do
        subject.valid?
        expect(subject.errors.include?('no content')).to be_true
      end
    end
  end

  describe "#file_path" do
    context "when id present" do
      subject { DeviceCloud::PushNotification::Message::FileData.new raw_file_data }

      its(:file_path) { should eq raw_file_data['id']['fdPath'] }
    end

    context "when id blank" do
      its(:file_path) { should eq '' }
    end
  end

  describe "#file_name" do
    context "when id present" do
      subject { DeviceCloud::PushNotification::Message::FileData.new raw_file_data }

      its(:file_name) { should eq raw_file_data['id']['fdName'] }
    end

    context "when id blank" do
      its(:file_name) { should eq '' }
    end
  end

  describe "#data" do
    context 'when valid' do
      subject { DeviceCloud::PushNotification::Message::FileData.new raw_file_data }

      its(:data) { should eq(JSON.parse(Base64.decode64(raw_file_data['fdData']))) }
    end

    context 'when invalid' do
      its(:data) { should be_false }
    end
  end

  describe "#full_path" do
    subject { DeviceCloud::PushNotification::Message::FileData.new raw_file_data }

    its(:full_path) { should eq(raw_file_data['id']['fdPath'] + raw_file_data['id']['fdName']) }
  end
end