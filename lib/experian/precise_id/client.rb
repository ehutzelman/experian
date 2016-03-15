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
        [request,response]
      rescue => e
        log_error(e)
        log_raw_response(raw_response)
      end

      def log_error(e)
        Experian.logger.error "#{e.message}. #{e.backtrace.join(', ')}" if Experian.logger
      end

      def log_raw_response(raw_response)
        if Experian.logger && raw_response
          Experian.logger.info "Status: #{raw_response.status}, Headers: #{raw_response.headers}, Body: #{raw_response.body}"
        elsif Experian.logger
          Experian.logger.error "Response was nil"
        end
      end

      def request_uri
        Experian.precice_id_uri
      end
    end
  end
end
