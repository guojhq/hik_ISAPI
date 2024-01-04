module Hikvision
  class Network
    class Integration < Hikvision::Base
      class << self
        def url
          "/ISAPI/System/Network/Integrate"
        end
      end

      def initialize(isapi)
        @isapi = isapi
      end

      add_xml(:base, url)

      add_setter(:cgi=, :base, '//CGI/enable', TrueClass, FalseClass)

      add_getter(:cgi_authentication, :base, '//CGI/certificateType') { |v| v.include?("basic") ? :basic : :digest }
      add_setter(:cgi_authentication=, :base, '//CGI/certificateType', Symbol) { |v| v == :basic ? "digest/basic" : v.to_s }

      add_bool_getter(:cgi?, :base, '//CGI/enable')
      add_bool_getter(:onvif?, :base, '//ONVIF/enable')
      add_bool_getter(:isapi?, :base, '//ISAPI/enable')
    end
  end
end
