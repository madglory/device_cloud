require 'spec_helper'

describe DeviceCloud::Request do
  let(:host) { 'example.com' }
  let(:path) { '/the/road/less/travelled' }
  let(:body) { 'badguts' }
  let(:username) { 'foo' }
  let(:password) { 'bar' }

  before(:each) do
    DeviceCloud.configure do |config|
      config.username = username
      config.password = password
      config.root_url = "https://#{host}"
    end
  end

  its(:path) { should be_nil }
  its(:body) { should be_nil }

  context 'when passed options' do
    subject { DeviceCloud::Request.new path: '/boom/boom/boom', body: 'HEYO' }

    its(:path) { should eq '/boom/boom/boom' }
    its(:body) { should eq 'HEYO' }
  end

  describe '#get' do
    before(:each) do
      stub_request(:get, "https://#{username}:#{password}@#{host}#{path}").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})
    end

    subject { DeviceCloud::Request.new(path: path) }

    its(:get) { should be_a(DeviceCloud::Response) }
  end

  describe '#post' do
    before(:each) do
      stub_request(:post, "https://#{username}:#{password}@#{host}#{path}").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}, body: body).
        to_return(:status => 200, :body => "", :headers => {})
    end

    subject { DeviceCloud::Request.new(path: path, body: body) }

    its(:post) { should be_a(DeviceCloud::Response) }
  end

  describe '#put' do
    before(:each) do
      stub_request(:put, "https://#{username}:#{password}@#{host}#{path}").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}, body: body).
        to_return(:status => 200, :body => "", :headers => {})
    end

    subject { DeviceCloud::Request.new(path: path, body: body) }

    its(:put) { should be_a(DeviceCloud::Response) }
  end

  describe '#delete' do
    before(:each) do
      stub_request(:delete, "https://#{username}:#{password}@#{host}#{path}").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})
    end

    subject { DeviceCloud::Request.new(path: path) }

    its(:delete) { should be_a(DeviceCloud::Response) }
  end
end
