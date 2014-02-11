require 'spec_helper'

describe DeviceCloud::Request do
  let(:path) { '/the/road/less/travelled' }
  let(:body) { 'badguts' }
  let(:request_uri) { authenticated_host + path }

  its(:path) { should be_nil }
  its(:body) { should be_nil }

  context 'when passed options' do
    subject { DeviceCloud::Request.new path: '/boom/boom/boom', body: 'HEYO' }

    its(:path) { should eq '/boom/boom/boom' }
    its(:body) { should eq 'HEYO' }
  end

  describe '#get' do
    before(:each) do
      stub_request(:get, request_uri).
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})
    end

    subject { DeviceCloud::Request.new(path: path) }

    its(:get) { should be_a(DeviceCloud::Response) }
  end

  describe '#post' do
    before(:each) do
      stub_request(:post, request_uri).
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}, body: body).
        to_return(:status => 200, :body => "", :headers => {})
    end

    subject { DeviceCloud::Request.new(path: path, body: body) }

    its(:post) { should be_a(DeviceCloud::Response) }
  end

  describe '#put' do
    before(:each) do
      stub_request(:put, request_uri).
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}, body: body).
        to_return(:status => 200, :body => "", :headers => {})
    end

    subject { DeviceCloud::Request.new(path: path, body: body) }

    its(:put) { should be_a(DeviceCloud::Response) }
  end

  describe '#delete' do
    before(:each) do
      stub_request(:delete, request_uri).
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})
    end

    subject { DeviceCloud::Request.new(path: path) }

    its(:delete) { should be_a(DeviceCloud::Response) }
  end
end
