module Experian
  module PreciseId
    class Request < Experian::Request
      def build_request
        super do |xml|
          xml.tag!("Experian") do
            xml.tag!('FraudSolutions') do
              xml.tag!('Request') do
                xml.tag!('Products') do
                  xml.tag!('PreciseIDServer') do
                    add_request_content(xml)
                  end
                end
              end
            end
          end
        end
      end

      def add_request_content(xml)
        raise "sub classes must override this method"
      end
    end
  end
end
