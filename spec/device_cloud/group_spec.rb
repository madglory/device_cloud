require 'spec_helper'

describe DeviceCloud::Group do
  describe '::all' do
    before(:each) do
      stub_request(:get, authenticated_host + '/ws/Group/.json').
               with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
               to_return(:status => 200, :body => groups_json, :headers => {})
    end

    subject { DeviceCloud::Group.all }

    context 'with results' do
      let(:groups_json) do
        "{\"resultTotalRows\": \"2\",\"requestedStartRow\": \"0\",\"resultSize\": \"2\",\"requestedSize\": \"1000\",\"remainingSize\": \"0\",\"items\": [{ \"grpId\": \"4946\", \"grpName\": \"Your_Company\", \"grpDescription\": \"Your_Company root group\", \"grpPath\": \"/Your_Company/\", \"grpParentId\": \"1\"},{ \"grpId\": \"9769\", \"grpName\": \"Sub_Group\", \"grpPath\": \"/Your_Company/Sub_Group/\", \"grpParentId\": \"4946\"}] }"
      end

      it { should be_a(Array) }
      its(:size) { should eq 2 }
      its(:first) { should be_a(DeviceCloud::Group) }
    end

    context 'with no results' do
      let(:groups_json) do
        "{\"resultTotalRows\": \"0\",\"requestedStartRow\": \"0\",\"resultSize\": \"0\",\"requestedSize\": \"1000\",\"remainingSize\": \"0\",\"items\": [] }"
      end

      it { should eq [] }
    end
  end

  describe '::find' do
    before(:each) do
      stub_request(:get, authenticated_host + '/ws/Group/123.json').
               with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
               to_return(:status => 200, :body => group_json, :headers => {})
    end

    subject { DeviceCloud::Group.find 123 }

    context 'with result' do
      let(:group_result) do
        {"resultTotalRows"=>"1",
         "requestedStartRow"=>"0",
         "resultSize"=>"1",
         "requestedSize"=>"1000",
         "remainingSize"=>"0",
         "items"=>
          [{"grpId"=>"9769",
            "grpDescription"=>"Describing this group.",
            "grpName"=>"Your_Company",
            "grpPath"=>"/Your_Company/Your_Group/",
            "grpParentId"=>"4946"}]}
      end
      let(:group_json) { group_result.to_json }

      it { should be_a(DeviceCloud::Group) }
      its(:grpId) { should eq group_result['items'].first['grpId'] }
      its(:grpDescription) { should eq group_result['items'].first['grpDescription'] }
      its(:grpName) { should eq group_result['items'].first['grpName'] }
      its(:grpPath) { should eq group_result['items'].first['grpPath'] }
      its(:grpParentId) { should eq group_result['items'].first['grpParentId'] }
    end

    context 'with no results' do
      let(:group_json) do
        {"error"=>["GET Group error. Error reading Group entity id='12123'"]}.to_json
      end

      it { should be_nil }
    end
  end
end
