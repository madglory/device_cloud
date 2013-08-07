require 'json'
require 'base64'

module DeviceCloud
  class PushNotification::Message::FileData
    attr_accessor :id, :fdLastModifiedDate, :fdSize, :fdContentType, :fdData, :fdArchive, :cstId, :fdType, :fdCreatedDate
    attr_reader :errors

    def initialize(attributes = {})
      @errors = []
      attributes.each do |name, value|
        send("#{name}=", value)
      end
      DeviceCloud.logger.warn "DeviceCloud::PushNotification::Message::FileData Invalid (#{errors.join(',')}) - #{full_path}" unless valid?
    end

    def full_path
      file_path + file_name
    end

    def data
      return false unless valid?
      @data ||= JSON.parse unencoded_data
    end

    def file_name
      return '' unless id
      id['fdName']
    end

    def file_path
      return '' unless id
      id['fdPath']
    end

    def valid?
      return false if @errors.any?
      validate_content_type! && validate_content!
    end
  private

    def unencoded_data
      @unencode_data ||= Base64.decode64(fdData)
    end

    def validate_content_type!
      if file_name =~ /\.json/
        true
      else
        @errors << 'wrong file type'
        false
      end
    end

    def validate_content!
      if fdData.size == 0 || fdSize.to_i < 1
        @errors << 'no content'
        false
      else
        true
      end
    end
  end
end