module DeviceCloud
  class Monitor
    attr_accessor :monId, :cstId, :monLastConnect, :monLastSent, :monTopic, :monTransportType, :monTransportToken, :monTransportUrl, :monFormatType, :monBatchSize, :monCompression, :monStatus, :monBatchDuration, :monAutoReplayOnConnect, :monLastSentUuid
    attr_reader :error

    DEFAULT_CREATE_OPTIONS = {
      'monTransportType' => 'http',
      'monTransportUrl' => "http://www.example.com/push_notifications",
      'monTransportToken' => "USERNAME:PASSWORD",
      'monFormatType' => 'json',
      'monBatchSize' => '1',
      'monCompression' => 'none',
      'monBatchDuration' => '0',
      'monAutoReplayOnConnect' => 'true'
    }

    class << self
      def all
        monitors = DeviceCloud::Request.new(path: '/ws/Monitor/.json').get.to_hash_from_json

        return [] unless monitors['resultSize'].to_i > 0

        monitors['items'].map { |monitor|
          Monitor.new monitor
        }
      end

      def find(monitor_id)
        monitors = DeviceCloud::Request.new(path: "/ws/Monitor/#{monitor_id}.json").get.to_hash_from_json

        return nil unless monitors['resultSize'].to_i > 0

        Monitor.new monitors['items'].first
      end
    end

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end

      @error = nil

      set_defaults
    end

    def persist!
      @error = nil
      monId.nil? ? create : update
    end

    def reset!
      @error = nil
      if monId.nil?
        @error = 'monId is nil'
        return false
      else
        reset_monitor!
      end
    end

    def destroy!
      return false if monId.nil?

      response = DeviceCloud::Request.new(path: "/ws/Monitor/#{monId}").delete

      response.code == '200' ? true : false
    end

    def attributes
      {
        'monTopic' => monTopic,
        'monTransportType' => monTransportType,
        'monTransportToken' => monTransportToken,
        'monTransportUrl' => monTransportUrl,
        'monFormatType' => monFormatType,
        'monBatchSize' => monBatchSize,
        'monCompression' => monCompression,
        'monBatchDuration' => monBatchDuration,
        'monAutoReplayOnConnect' => monAutoReplayOnConnect
      }
    end

  private
    def set_defaults
      DEFAULT_CREATE_OPTIONS.each do |option, value|
        send("#{option}=", value) if attributes[:option].nil?
      end
    end

    def create
      response = DeviceCloud::Request.new(path: '/ws/Monitor', body: to_xml).post
      if response.code == '201'
        self.monId = response.headers['location'][0].sub(/Monitor\//, '')
        return true
      else
        @error = error_from_response_xml(response)
        return false
      end
    end

    def update
      response = DeviceCloud::Request.new(path: "/ws/Monitor/#{monId}", body: to_xml).put

      if response.code == '200'
        return true
      else
        @error = error_from_response_xml(response)
        return false
      end
    end

    def reset_monitor!
      response = DeviceCloud::Request.new(path: "/ws/Monitor", body: reset_xml).put

      if response.code == '200'
        return true
      else
        @error = error_from_response_xml(response)
        return false
      end
    end

    def reset_xml
      "<Monitor><monId>#{monId}</monId></Monitor>"
    end

    def to_xml
      xml = '<Monitor>'
      attributes.each do |key,value|
        xml << "<#{key}>#{value}</#{key}>"
      end
      xml << '</Monitor>'
    end

    def error_from_response_xml(response)
      response.body.match(/<error>(.*)<\/error>/)[1]
    end
  end
end
