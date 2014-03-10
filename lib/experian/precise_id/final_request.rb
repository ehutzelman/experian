module Experian
  module PreciseId
    class FinalRequest < Request

      def add_request_content(xml)
        xml.tag!("KBAAddOn") do
          xml.tag!('XMLVersion', "5.0")
          xml.tag!('KBAAnswers') do
            xml.tag!('OutWalletAnswerData') do
              xml.tag!('SessionID', @options[:session_id])
              xml.tag!('OutWalletAnswers') do
                @options[:answers].each_with_index do |question,index|
                  xml.tag!("OutWalletAnswer#{index+1}", question)
                end
              end
            end
          end
        end
      end

    end
  end
end
