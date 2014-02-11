require 'spec_helper'

describe DeviceCloud::Response do
  let(:headers_hash) do
    { 'location' => ['here'] }
  end
  let(:header) do
    OpenStruct.new to_hash: headers_hash
  end
  let(:message) { 'OK' }
  let(:code) { 200 }
  let(:body) { 'HEYO' }
  let(:http_response) do
    OpenStruct.new(
      code: code,
      message: message,
      header: header,
      body: body
    )
  end

  subject { DeviceCloud::Response.new http_response }

  its(:code) { should eq code }
  its(:message) { should eq message }
  its(:body) { should eq body }
  its(:headers) { should eq headers_hash }

  describe '#to_hash_from_json' do
    context 'when valid JSON' do
      let(:json) do
        {
          'hello' => 'world'
        }
      end
      let(:body) { json.to_json }

      its(:to_hash_from_json) { should eq json }
    end

    context 'when not valid json' do
      it 'raises an error' do
        expect{ subject.to_hash_from_json }.to raise_error(JSON::ParserError)
      end
    end
  end
end
