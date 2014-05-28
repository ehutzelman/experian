module Experian
  module PreciseId
    class Request < Experian::Request
      def build_request
        super do |xml|
          xml.tag!('EAI', Experian.eai)
          xml.tag!('DBHost', PreciseId.db_host)
          add_reference_id(xml)
          xml.tag!('Request', :version => '1.0', :xmlns => Experian::XML_REQUEST_NAMESPACE) do
            xml.tag!('Products') do
              xml.tag!('PreciseIDServer') do
                add_request_content(xml)
              end
            end
          end
        end
      end

      def add_reference_id(xml)
        xml.tag!('ReferenceId', @options[:reference_id]) if @options[:reference_id]
      end

      def add_request_content(xml)
        raise "sub classes must override this method"
      end
    end
  end
end
