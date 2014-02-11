require 'net/http'

module DeviceCloud
  # Public: Used to send Net::HTTP requests.
  #
  # Examples:
  #
  #   get_response = DeviceCloud::Request.new("/ws/FileData").get
  #   post_response = DeviceCloud::Request.new("/ws/sci").post(data)
  class Request
    attr_reader :path, :body

    # Public: Create a new instance of Request.
    #
    # path - The path String to use.
    def initialize(options = {})
      @path = options[:path]
      @body = options[:body]
    end

    # Public: Send a GET request.
    #
    # Returns a DeviceCloud::Response instance.
    def get
      make_request do
        Net::HTTP::Get.new request_uri
      end
    end

    # Public: Send a POST request.
    #
    # body
    #
    # Returns a DeviceCloud::Response instance.
    def post
      make_request do
        Net::HTTP::Post.new request_uri
      end
    end

    # Public: Send a PUT request.
    #
    # body
    #
    # Returns a DeviceCloud::Response instance.
    def put
      make_request do
        Net::HTTP::Put.new request_uri
      end
    end

    # Public: Send a DELETE request.
    #
    # Returns a DeviceCloud::Response instance.
    def delete
      make_request do
        Net::HTTP::Delete.new request_uri
      end
    end

  private
    def request_uri
      uri.request_uri
    end

    def uri
      @uri ||= URI.parse(DeviceCloud.root_url + path)
    end

    def make_request
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = yield
        request.basic_auth DeviceCloud.username, DeviceCloud.password

        DeviceCloud::Response.new http.request(request, body)
      end
    end
  end
end
