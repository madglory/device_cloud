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
      stub_request(:get, "https://foouser:barpass@my.idigi.com/ws/AlarmTemplate").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response_body, :headers => {})
    end

    subject { DeviceCloud::AlarmTemplate.all }

    context 'when results are found' do
      let(:response_body) do
        %{<?xml version="1.0" encoding="ISO-8859-1"?>
        <result>
          <resultTotalRows>1</resultTotalRows>
          <requestedStartRow>0</requestedStartRow>
          <resultSize>1</resultSize>
          <requestedSize>1000</requestedSize>
          <remainingSize>0</remainingSize>
          <AlarmTemplate>
            <almtId>2</almtId>
            <almtName>Device Offline</almtName>
            <almtDescription>Detects when a device disconnects from Device Cloud and fails to reconnected within the specified time</almtDescription>
            <grpId>1</grpId>
            <almtTopic>Alarm.DeviceOffline</almtTopic>
            <almtScopeOptions>
              <ScopingOptions>
                <Scope name="Group"/>
              <Scope name="Device"/>
            </ScopingOptions>
            </almtScopeOptions>
            <almtRules>
              <Rules>
                <FireRule name="fireRule1">
                  <Variable name="reconnectWindowDuration" type="int"/>
                </FireRule>
                <ResetRule name="resetRule1"></ResetRule>
              </Rules>
            </almtRules>
            <almtResourceList>DeviceCore,AlarmStatus</almtResourceList>
          </AlarmTemplate>
        </result>}
      end

      it { should be_a(Array) }
      its(:first) { should be_a(DeviceCloud::AlarmTemplate) }
      its(:size) { should eq 1 }
    end

    context 'when results are not found' do
      let(:response_body) do
        %{<?xml version="1.0" encoding="ISO-8859-1"?>
        <result>
          <resultTotalRows>0</resultTotalRows>
          <requestedStartRow>0</requestedStartRow>
          <resultSize>0</resultSize>
          <requestedSize>1000</requestedSize>
          <remainingSize>0</remainingSize>
        </result>}
      end

      it { should eq [] }
    end
  end

  describe '::find' do
    before(:each) do
      stub_request(:get, "https://foouser:barpass@my.idigi.com/ws/AlarmTemplate/2").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response_body, :headers => {})
    end

    subject { DeviceCloud::AlarmTemplate.find 2 }

    context 'when result is found' do
      let(:response_body) do
        %{<?xml version="1.0" encoding="ISO-8859-1"?>
        <result>
          <resultTotalRows>1</resultTotalRows>
          <requestedStartRow>0</requestedStartRow>
          <resultSize>1</resultSize>
          <requestedSize>1000</requestedSize>
          <remainingSize>0</remainingSize>
          <AlarmTemplate>
            <almtId>2</almtId>
            <almtName>Device Offline</almtName>
            <almtDescription>Detects when a device disconnects from Device Cloud and fails to reconnected within the specified time</almtDescription>
            <grpId>1</grpId>
            <almtTopic>Alarm.DeviceOffline</almtTopic>
            <almtScopeOptions>
              <ScopingOptions>
                <Scope name="Group"/>
                <Scope name="Device"/>
              </ScopingOptions>
            </almtScopeOptions>
            <almtRules>
              <Rules>
                <FireRule name="fireRule1">
                  <Variable name="reconnectWindowDuration" type="int"/>
                </FireRule>
                <ResetRule name="resetRule1"></ResetRule>
              </Rules>
            </almtRules>
            <almtResourceList>DeviceCore,AlarmStatus</almtResourceList>
          </AlarmTemplate>
        </result>}
      end

      it { should be_a(DeviceCloud::AlarmTemplate) }
    end

    context 'when result is not found' do
      let(:response_body) do
        %{<?xml version="1.0" encoding="ISO-8859-1"?>
        <result>
          <error>GET AlarmTemplate error. Error reading AlarmTemplate entity id='212'</error>
        </result>}
      end

      it { should be_nil }
    end
  end
end
