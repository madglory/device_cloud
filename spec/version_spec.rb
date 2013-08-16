require 'spec_helper'

describe 'DeviceCloud::VERSION' do
  it 'should be the correct version' do
    DeviceCloud::VERSION.should == '0.1.0'
  end
end