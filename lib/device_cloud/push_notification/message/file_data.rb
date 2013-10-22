require 'json'
require 'base64'

module DeviceCloud
  class PushNotification::Message::FileData
    attr_accessor :id, :fdLastModifiedDate, :fdSize, :fdContentType, :fdData, :fdArchive, :cstId, :fdType, :fdCreatedDate
    attr_reader :no_content

    def initialize(attributes = {})
      @no_content = false
      attributes.each do |name, value|
        send("#{name}=", value)
      end
      validate_content!
    end

    def full_path
      file_path + file_name
    end

    def content_type
      fdContentType
    end

    def data
      @data ||= if json_data? && content?
        JSON.parse unencoded_data
      else
        unencoded_data
      end
    end

    def file_name
      return '' unless id && id['fdName']
      id['fdName']
    end

    def file_path
      return '' unless id && id['fdPath']
      id['fdPath']
    end

    def no_content?
      @no_content
    end

    def content?
      !no_content?
    end
  private
    def json_data?
      fdContentType =~ /json/ || file_name =~ /\.json\z/
    end

    def unencoded_data
      @unencoded_data ||= no_content? ? '' : Base64.decode64(fdData)
    end

    def validate_content!
      @no_content = !fdData || fdData.size == 0 || fdSize.to_i < 1
    end
  end
end