module Experian
  module PreciseId
    class Client < Experian::Client

      def check_id(options = {})
        @request = PrimaryRequest.new(options)
        @response = Response.new(submit_request)
      end

      def request_questions(options = {})
        @request = SecondaryRequest.new(options)
        @response = Response.new(submit_request)
      end

      def send_answers(options = {})
        @request = FinalRequest.new(options)
        @response = Response.new(submit_request)
      end

    end
  end
end
