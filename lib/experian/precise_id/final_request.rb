module Experian
  module PreciseId
    class FinalRequest < Request

      def add_request_content(xml)
        xml.tag!('XMLVersion', "05")
        xml.tag!('KBAAnswers') do
          xml.tag!('OutWalletAnswerData') do
            xml.tag!('SessionID', @options[:session_id])
            add_answers(xml,@options[:answers]) if @options[:answers]
          end
        end
      end

      private

      def add_answers(xml, answers)
        xml.tag!('OutWalletAnswers') do
          answers.each_with_index do |question,index|
            xml.tag!("OutWalletAnswer#{index+1}", question)
          end
        end
      end

    end
  end
end
