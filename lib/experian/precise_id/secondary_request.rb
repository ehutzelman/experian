module Experian
  module PreciseId
    class SecondaryRequest < Request

      def add_request_content(xml)
        xml.tag!('PIDXMLVersion', "06.00")
        xml.tag!('KBAAddOn') do
          xml.tag!('OutWalletRequestData') do
            xml.tag!('SessionID', @options[:session_id])
            xml.tag!('OutWalletQuestionsRequest', "Y")
          end
        end
      end

    end
  end
end
