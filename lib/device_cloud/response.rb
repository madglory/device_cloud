module DeviceCloud
  class Response
    attr_reader :code, :message, :headers, :body, :original_response

    def initialize(http_response)
      @original_response = http_response
      @code = original_response.code
      @message = original_response.message
      @headers = original_response.header.to_hash
      @body = original_response.body
    end

    def to_hash_from_xml
      DeviceCloud.xml_parser.parse(body)
    end

    def to_hash_from_json
      JSON.parse(body)
    end
  end
end
