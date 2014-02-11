require 'spec_helper'

describe DeviceCloud::Monitor do

  describe '::all' do
    before(:each) do
      stub_request(:get, authenticated_host + '/ws/Monitor/.json').
               with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
               to_return(:status => 200, :body => monitors_json, :headers => {})
    end

    subject { DeviceCloud::Monitor.all }

    context 'with results' do
      let(:monitors_json) do
        {
              "resultTotalRows" => "1",
            "requestedStartRow" => "0",
                   "resultSize" => "1",
                "requestedSize" => "1000",
                "remainingSize" => "0",
                        "items" => [
                {
                                     "monId" => "109012",
                                     "cstId" => "4044",
                            "monLastConnect" => "2014-02-05T18:57:49.603Z",
                               "monLastSent" => "2014-02-11T02:38:46.770Z",
                                  "monTopic" => "[group=Staging]FileData/*.*",
                          "monTransportType" => "http",
                           "monTransportUrl" => "http://example.com/device_cloud/push_notifications",
                             "monFormatType" => "json",
                              "monBatchSize" => "1",
                            "monCompression" => "none",
                                 "monStatus" => "ACTIVE",
                          "monBatchDuration" => "0",
                    "monAutoReplayOnConnect" => "true",
                           "monLastSentUuid" => "a18afa9d-92c5-11e3-a346-bc764e1023af"
                }
            ]
        }.to_json
      end

      it { should be_a(Array) }
      its(:size) { should eq 1 }
      its(:first) { should be_a(DeviceCloud::Monitor) }
    end

    context 'with no results' do
      let(:monitors_json) do
        {
          "resultTotalRows"=>"0",
          "requestedStartRow"=>"0",
          "resultSize"=>"0",
          "requestedSize"=>"1000",
          "remainingSize"=>"0",
          "items"=>[]
        }.to_json
      end

      it { should eq [] }
    end
  end

  describe '::find' do
    before(:each) do
      stub_request(:get, authenticated_host + '/ws/Monitor/123.json').
               with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
               to_return(:status => 200, :body => monitor_json, :headers => {})
    end

    subject { DeviceCloud::Monitor.find 123 }

    context 'with result' do
      let(:monitor_json) do
        {"resultTotalRows"=>"1",
         "requestedStartRow"=>"0",
         "resultSize"=>"1",
         "requestedSize"=>"1000",
         "remainingSize"=>"0",
         "items"=>
          [{"monId"=>"109012",
            "cstId"=>"4044",
            "monLastConnect"=>"2014-02-05T18:57:49.603Z",
            "monLastSent"=>"2014-02-11T02:54:07.143Z",
            "monTopic"=>"[group=Staging]FileData/*.*",
            "monTransportType"=>"http",
            "monTransportUrl"=>
             "http://example.com/device_cloud/push_notifications",
            "monFormatType"=>"json",
            "monBatchSize"=>"1",
            "monCompression"=>"none",
            "monStatus"=>"ACTIVE",
            "monBatchDuration"=>"0",
            "monAutoReplayOnConnect"=>"true",
            "monLastSentUuid"=>"7b4b2515-92c7-11e3-a346-bc764e1023af"}]}.to_json
      end

      it { should be_a(DeviceCloud::Monitor) }
    end

    context 'with no results' do
      let(:monitor_json) do
        {"error"=>["GET Monitor error. Error reading Monitor entity id='12123'"]}.to_json
      end

      it { should be_nil }
    end
  end

  describe '#persist!' do
    context 'when monId is nil' do
      let(:request_body) { new_monitor.send(:to_xml) }
      before(:each) do
        stub_request(:post, authenticated_host + '/ws/Monitor').
                 with(:body => request_body,
                      :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
                 to_return(:status => response_status, :body => response_body, :headers => response_headers)
      end

      subject { new_monitor }

      context 'when successful' do
        let(:new_monitor) { DeviceCloud::Monitor.new monTopic: 'AlarmStatus' }
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result>\n   <location>Monitor/115848</location>\n</result>" }
        let(:response_status) { 201 }
        let(:response_headers) do
          { 'location' => ['Monitor/1234567'] }
        end


        its(:persist!) { should be_true }

        context 'after #persist!' do
          before(:each) { subject.persist! }
          its(:monId) { should_not be_nil }
          its(:error) { should be_nil }
        end
      end

      context 'when unsuccessful' do
        let(:new_monitor) { DeviceCloud::Monitor.new monTopic: 'Invalid' }
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result>\n   <error>POST Monitor error. Invalid request. Invalid monTopic specified</error>\n</result>" }
        let(:response_status) { 400 }
        let(:response_headers) { Hash.new }

        its(:persist!) { should be_false }

        context 'after #persist!' do
          before(:each) { subject.persist! }
          its(:monId) { should be_nil }
          its(:error) { should eq "POST Monitor error. Invalid request. Invalid monTopic specified" }
        end
      end
    end

    context 'when monId is not nil' do
      let(:request_body) { existing_monitor.send(:to_xml) }
      before(:each) do
        stub_request(:put, "https://foouser:barpass@my.idigi.com/ws/Monitor/12345").
          with(:body => request_body,
                      :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => response_status, :body => response_body, :headers => {})
      end

      subject { existing_monitor }

      context 'when successful' do
        let(:existing_monitor) { DeviceCloud::Monitor.new monTopic: 'FileData', monId: 12345 }
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result/>" }
        let(:response_status) { 200 }

        its(:persist!) { should be_true }

        context 'after #persist!' do
          before(:each) { subject.persist! }
          its(:error) { should be_nil }
        end
      end

      context 'when unsuccessful' do
        let(:existing_monitor) { DeviceCloud::Monitor.new monTopic: 'Invalid', monId: 12345 }
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result>\n   <error>PUT Monitor error. Invalid request. Invalid monTopic specified</error>\n</result>" }
        let(:response_status) { 400 }

        its(:persist!) { should be_false }

        context 'after #persist!' do
          before(:each) { subject.persist! }
          its(:error) { should eq "PUT Monitor error. Invalid request. Invalid monTopic specified" }
        end
      end
    end
  end

  describe '#destroy!' do
    context 'when monId is nil' do
      its(:destroy!) { should be_false }
    end

    context 'when monId is not nil' do
      let(:existing_monitor) { DeviceCloud::Monitor.new monId: 12345 }
      before(:each) do
        stub_request(:delete, "https://foouser:barpass@my.idigi.com/ws/Monitor/12345").
                 with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
                 to_return(:status => response_status, :body => response_body, :headers => {})
      end

      subject { existing_monitor.destroy! }

      context 'when successful' do
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result>\n   <message>1 items deleted</message>\n</result>" }
        let(:response_status) { 200 }

        it { should be_true }
      end

      context 'when unsuccessful' do
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result>\n   <error>DELETE Monitor error. Invalid request. For input string: \"gigo\"</error>\n</result>" }
        let(:response_status) { 400 }

        it { should be_false }
      end
    end
  end

  describe '#reset!' do
    context 'when monId is nil' do
      its(:reset!) { should be_false }

      context 'after #reset!' do
        before(:each) { subject.reset! }

        its(:error) { should eq 'monId is nil'}
      end
    end

    context 'when monId is not nil' do
      before(:each) do
        stub_request(:put, "https://foouser:barpass@my.idigi.com/ws/Monitor").
           with(:body => request_body,
                :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
           to_return(:status => response_status, :body => response_body, :headers => {})
      end


      context 'when successful' do
        subject { DeviceCloud::Monitor.new monId: 12345 }
        let(:request_body) { '<Monitor><monId>12345</monId></Monitor>'}
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result/>" }
        let(:response_status) { 200 }

        its(:reset!) { should be_true }

        context 'after #reset!' do
          before(:each) { subject.reset! }

          its(:error) { should be_nil }
        end
      end

      context 'when unsuccessful' do
        subject { DeviceCloud::Monitor.new monId: 1 }
        let(:request_body) { '<Monitor><monId>1</monId></Monitor>' }
        let(:response_body) { "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<result>\n   <error>PUT Monitor error. Error reading Monitor entity id='&lt;monId&gt;1&lt;/monId&gt;'</error>\n</result>" }
        let(:response_status) { 400 }

        its(:reset!) { should be_false }

        context 'after #reset!' do
          before(:each) { subject.reset! }

          its(:error) { should eq "PUT Monitor error. Error reading Monitor entity id='&lt;monId&gt;1&lt;/monId&gt;'"}
        end
      end
    end
  end
end
