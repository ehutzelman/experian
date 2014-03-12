module Experian
  module PasswordReset
    class Response
      attr_reader :body

      def initialize(body)
        @body = body
      end

      def success?
        true
      end
    end
  end
end
