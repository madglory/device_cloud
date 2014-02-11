require 'spec_helper'

describe DeviceCloud::AlarmTemplate do

  its(:almtId) { should be_nil }
  its(:almtName) { should be_nil }
  its(:almtDescription) { should be_nil }
  its(:grpId) { should be_nil }
  its(:almtTopic) { should be_nil }
  its(:almtScopeOptions) { should be_nil }
  its(:almtRules) { should be_nil }
  its(:almtResourceList) { should be_nil }

  context 'when attributes given' do
    let(:attributes) do
      {
        almtId: 'foo',
        almtName: 'foo',
        almtDescription: 'foo',
        grpId: 'foo',
        almtTopic: 'foo',
        almtScopeOptions: 'foo',
        almtRules: 'foo',
        almtResourceList: 'foo'
      }
    end

    subject { DeviceCloud::AlarmTemplate.new attributes }

    its(:almtId) { should eq 'foo' }
    its(:almtName) { should eq 'foo' }
    its(:almtDescription) { should eq 'foo' }
    its(:grpId) { should eq 'foo' }
    its(:almtTopic) { should eq 'foo' }
    its(:almtScopeOptions) { should eq 'foo' }
    its(:almtRules) { should eq 'foo' }
    its(:almtResourceList) { should eq 'foo' }
  end

  describe '::all' do
    before(:each) do
      stub_request(:get, "https://foouser:barpass@my.idigi.com/ws/AlarmTemplate/.json").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response_body, :headers => {})
    end

    subject { DeviceCloud::AlarmTemplate.all }

    context 'when results are found' do
      let(:response_body) do
        {
          "resultTotalRows" => "1",
          "requestedStartRow" => "0",
          "resultSize" => "1",
          "requestedSize" => "1000",
          "remainingSize" => "0",
          "items" => [
            {
              "almtId" => "2",
              "almtName" => "Device Offline",
              "almtDescription" => "Detects when a device disconnects from Device Cloud and fails to reconnected within the specified time",
              "grpId" => "1",
              "almtTopic" => "Alarm.DeviceOffline",
              "almtScopeOptions" => {
                "ScopingOptions" => {
                  "Scope" => ""
                }
              },
              "almtRules" => {
                "Rules" => {
                  "FireRule" => { "Variable" => "" }, "ResetRule" => "" }
              },
              "almtResourceList" => "DeviceCore,AlarmStatus"
            }
          ]
        }.to_json
      end

      it { should be_a(Array) }
      its(:first) { should be_a(DeviceCloud::AlarmTemplate) }
      its(:size) { should eq 1 }
    end

    context 'when results are not found' do
      let(:response_body) { "{\n    \"resultTotalRows\": \"0\",\n    \"requestedStartRow\": \"0\",\n    \"resultSize\": \"0\",\n    \"requestedSize\": \"1000\",\n    \"remainingSize\": \"0\",\n    \"items\": [\n    ]\n }\n" }

      it { should eq [] }
    end
  end

  describe '::find' do
    before(:each) do
      stub_request(:get, "https://foouser:barpass@my.idigi.com/ws/AlarmTemplate/2.json").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response_body, :headers => {})
    end

    subject { DeviceCloud::AlarmTemplate.find 2 }

    context 'when result is found' do
      let(:response_body) do
        "{\n    \"resultTotalRows\": \"1\",\n    \"requestedStartRow\": \"0\",\n    \"resultSize\": \"1\",\n    \"requestedSize\": \"1000\",\n    \"remainingSize\": \"0\",\n    \"items\": [\n{ \"almtId\": \"2\", \"almtName\": \"Device Offline\", \"almtDescription\": \"Detects when a device disconnects from Device Cloud and fails to reconnected within the specified time\", \"grpId\": \"1\", \"almtTopic\": \"Alarm.DeviceOffline\", \"almtScopeOptions\": { \"ScopingOptions\": { \"Scope\": \"\", \"Scope\": \"\"}}, \"almtRules\": { \"Rules\": { \"FireRule\": { \"Variable\": \"\"}, \"ResetRule\": \"\"}}, \"almtResourceList\": \"DeviceCore,AlarmStatus\"}\n   ]\n }\n"
      end

      it { should be_a(DeviceCloud::AlarmTemplate) }
    end

    context 'when result is not found' do
      let(:response_body) { "{\n \"error\":  [\"GET AlarmTemplate error. Error reading AlarmTemplate entity id='2'\"]\n}" }

      it { should be_nil }
    end
  end
end
