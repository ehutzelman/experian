module Experian
  module PreciseId
    class SecondaryRequest < Request

      def add_request_content(xml)
        xml.tag!('KBAAddOn') do
          xml.tag!('XMLVersion', "05")
          xml.tag!('OutWalletRequestData') do
            xml.tag!('SessionID', @options[:session_id])
            xml.tag!('OutWalletQuestionsRequest', "Y")
          end
        end
      end

    end
  end
end
