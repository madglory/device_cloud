require 'erb'
require 'net/http'

module DeviceCloud
  class DeviceCore

    # Install a new device on Device Cloud for the given settings.
    # Possible Settings:
    #   * dev_connect_ware_id
    #   * dev_mac
    #   * dp_description
    #   * dp_map_lat
    #   * dp_map_long
    #   * grp_path
    #
    def self.install_new_device(settings)
      execute_request Net::HTTP::Post, settings
    end

    def self.update_existing_device(settings)
      execute_request Net::HTTP::Put, settings
    end

    def self.fetch_all_existing_devices
      execute_request Net::HTTP::Get
    end

  private

    def self.execute_request(request_type, settings)
      uri     = URI.parse device_core_url
      request = request_type.new uri.request_uri

      request.basic_auth(DeviceCloud.username, DeviceCloud.password)

      Net::HTTP.start uri.host, uri.port, use_ssl: true do |http|
        return http.request request, device_core_request_template(settings)
      end
    end

    def self.device_core_url
      "#{DeviceCloud.root_url}/ws/DeviceCore"
    end

    def self.device_core_request_template(settings)
      #
      ## TODO: This should really be built with something other than ERB
      #
      template = ERB.new <<-XML
<DeviceCore>
<% if settings[:dev_connect_ware_id] %>
  <devConnectwareId><%= settings[:dev_connect_ware_id] %></devConnectwareId>
<% end %>

<% if settings[:dev_mac] %>
  <devMac><%= settings[:dev_mac] %></devMac>
<% end %>

<% if settings[:dp_map_lat] && settings[:dp_map_long] %>
  <dpMapLat><%= settings[:dp_map_lat] %></dpMapLat>
  <dpMapLong><%= settings[:dp_map_long] %></dpMapLong>
<% end %>

<% if settings[:dp_description] %>
  <dpDescription><%= settings[:dp_description] %></dpDescription>
<% end %>

<% if settings[:grp_path] %>
  <grpPath><%= settings[:grp_path] %></grpPath>
<% end %>
</DeviceCore>
XML
      template.result(binding)
    end

  end
end
