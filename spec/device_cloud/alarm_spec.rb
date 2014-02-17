require 'spec_helper'

describe DeviceCloud::Alarm do
  its(:almId) { should be_nil }
  its(:cstId) { should be_nil }
  its(:almtId) { should be_nil }
  its(:grpId) { should be_nil }
  its(:almName) { should be_nil }
  its(:almDescription) { should be_nil }
  its(:almScopeConfig) { should be_nil }
  its(:almRuleConfig) { should be_nil }
  its(:almEnabled) { should be_nil }
  its(:almPriority) { should be_nil }
  its(:error) { should be_nil }

  context 'when attributes given' do
    let(:attributes) do
      {
        almId: 'foo',
        cstId: 'foo',
        almtId: 'foo',
        grpId: 'foo',
        almName: 'foo',
        almDescription: 'foo',
        almScopeConfig: 'foo',
        almRuleConfig: 'foo',
        almEnabled: true,
        almPriority: 2
      }
    end

    subject { DeviceCloud::Alarm.new attributes}

    its(:almId) { should eq 'foo' }
    its(:cstId) { should eq 'foo' }
    its(:almtId) { should eq 'foo' }
    its(:grpId) { should eq 'foo' }
    its(:almName) { should eq 'foo' }
    its(:almDescription) { should eq 'foo' }
    its(:almScopeConfig) { should eq 'foo' }
    its(:almRuleConfig) { should eq 'foo' }
    its(:almEnabled) { should eq true }
    its(:almPriority) { should eq 2 }
  end

  describe '::all' do
    let(:group_body) do
      %{{"resultTotalRows": "1","requestedStartRow": "0","resultSize": "1","requestedSize": "1000","remainingSize": "0","items": [{ "grpId": "9769", "grpName": "Staging", "grpPath": "/4044_MadGlory_Interactive/Staging/", "grpParentId": "4946"}] }}
    end

    before(:each) do
      stub_request(:get, "https://foouser:barpass@my.idigi.com/ws/Alarm").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response_body, :headers => {})
    end

    subject { DeviceCloud::Alarm.all }

    context 'when results are found' do
      before(:each) do
        stub_request(:get, "https://foouser:barpass@my.idigi.com/ws/Group/9769.json").
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => group_body, :headers => {})
      end

      let(:response_body) do
        %{<?xml version="1.0" encoding="ISO-8859-1"?>
        <result>
           <resultTotalRows>1</resultTotalRows>
           <requestedStartRow>0</requestedStartRow>
           <resultSize>1</resultSize>
           <requestedSize>1000</requestedSize>
           <remainingSize>0</remainingSize>
           <Alarm>
              <almId>1898</almId>
              <cstId>4044</cstId>
              <almtId>#{almtId}</almtId>
              <grpId>9769</grpId>
              <almName>Staging Device Disconnect</almName>
              <almDescription>Detects when a device disconnects from Device Cloud and fails to reconnected within the specified time</almDescription>
              <almEnabled>true</almEnabled>
              <almPriority>1</almPriority>
              <almScopeConfig>
                 <ScopingOptions>
                    <Scope name="Group" value="/4044_MadGlory_Interactive/Staging/"/>
                 </ScopingOptions>
              </almScopeConfig>
              <almRuleConfig>
                 <Rules>
                    <FireRule name="fireRule1">
                       <Variable name="reconnectWindowDuration" value="5"/>
                    </FireRule>
                    <ResetRule name="resetRule1"/>
                 </Rules>
              </almRuleConfig>
           </Alarm>
         </result>}
      end


      context 'result has a known almtId' do
        let(:almtId) { 2 }

        it { should be_a(Array) }
        its(:first) { should be_a(DeviceCloud::DeviceDisconnectAlarm) }
      end

      context 'result has unknown almtId' do
        let(:almtId) { 26 }

        it { should be_a(Array) }
        its(:first) { should be_a(DeviceCloud::Alarm) }
      end
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
      stub_request(:get, "https://foouser:barpass@my.idigi.com/ws/Alarm/1898").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response_body, :headers => {})
    end

    subject { DeviceCloud::Alarm.find 1898 }

    context 'when result is found' do
      let(:group_body) do
        %{{"resultTotalRows": "1","requestedStartRow": "0","resultSize": "1","requestedSize": "1000","remainingSize": "0","items": [{ "grpId": "9769", "grpName": "Staging", "grpPath": "/4044_MadGlory_Interactive/Staging/", "grpParentId": "4946"}] }}
      end

      before(:each) do
        stub_request(:get, "https://foouser:barpass@my.idigi.com/ws/Group/9769.json").
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => group_body, :headers => {})
      end

      let(:response_body) do
        %{<?xml version="1.0" encoding="ISO-8859-1"?>
          <result>
           <resultTotalRows>1</resultTotalRows>
           <requestedStartRow>0</requestedStartRow>
           <resultSize>1</resultSize>
           <requestedSize>1000</requestedSize>
           <remainingSize>0</remainingSize>
           <Alarm>
              <almId>1898</almId>
              <cstId>4044</cstId>
              <almtId>#{almtId}</almtId>
              <grpId>9769</grpId>
              <almName>Staging Device Disconnect</almName>
              <almDescription>Detects when a device disconnects from Device Cloud and fails to reconnected within the specified time</almDescription>
              <almEnabled>true</almEnabled>
              <almPriority>1</almPriority>
              <almScopeConfig>
                 <ScopingOptions>
                    <Scope name="Group" value="/4044_MadGlory_Interactive/Staging/"/>
                 </ScopingOptions>
              </almScopeConfig>
              <almRuleConfig>
                 <Rules>
                    <FireRule name="fireRule1">
                       <Variable name="reconnectWindowDuration" value="5"/>
                    </FireRule>
                    <ResetRule name="resetRule1"/>
                 </Rules>
              </almRuleConfig>
           </Alarm>
           </result>}
      end

      context 'with a known almtId' do
        let(:almtId) { 2 }
        it { should be_a(DeviceCloud::DeviceDisconnectAlarm) }
      end

      context 'with an unknown almtId' do
        let(:almtId) { 26 }
        it { should be_a(DeviceCloud::Alarm)}
      end
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

  describe '#persist!' do
    subject { DeviceCloud::Alarm.new }

    it 'raises NotImplementedError' do
      expect { subject.persist! }.to raise_error(NotImplementedError)
    end
  end

  describe '#destroy!' do
    context 'when almId is nil' do
      its(:destroy!) { should be_false }
    end

    context 'when almId is not nil' do
      let(:existing_alarm) { DeviceCloud::Alarm.new almId: 12345 }
      before(:each) do
        stub_request(:delete, "https://foouser:barpass@my.idigi.com/ws/Alarm/12345").
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => response_status, :body => response_body, :headers => {})
      end

      subject { existing_alarm.destroy! }

      context 'when successful' do
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result>\n   <message>1 items deleted</message>\n</result>" }
        let(:response_status) { 200 }

        it { should be_true }
      end

      context 'when unsuccessful' do
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result>\n   <error>DELETE Alarm error. Invalid request. For input string: \"gigo\"</error>\n</result>" }
        let(:response_status) { 400 }

        it { should be_false }
      end
    end
  end
end
