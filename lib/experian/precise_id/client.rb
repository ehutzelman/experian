module Experian
  module PreciseId
    class Client < Experian::Client

      def check_id(options = {})
        submit_request(PrimaryRequest.new(options))
      end

      def request_questions(options = {})
        submit_request(SecondaryRequest.new(options))
      end

      def send_answers(options = {})
        submit_request(FinalRequest.new(options))
      end

      private

      def submit_request(request)
        raw_response = super
        response = Response.new(raw_response.body)
        check_response(response,raw_response)
        [request,response]
      end

      def check_response(response,raw_response)
        if Experian.logger && response.error? && (response.error_code.nil? && response.error_message.nil?)
          Experian.logger.debug "Unknown Experian Error Detected, Raw response: #{raw_response}"
        end
      end

      def request_uri
        Experian.precice_id_uri
      end

    end
  end
end
