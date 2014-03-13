module Experian
  module PasswordReset
    class Client < Experian::Client

      def request_password
        @request = Request.new(command: 'requestnewpassword')
        submit_request # populates @raw_response, body returns ""
        @raw_response.headers["Response"]
      end

      def reset_password(new_password)
        @request = Request.new(new_password: new_password, command: 'resetpassword')
        submit_request
        @raw_response.headers["Response"] == "SUCCESS"
      end

      def request_uri
        # setup basic authentication
        uri = URI.parse(Experian::Constants::PASSWORD_RESET_URL)
        uri.user = Experian.user
        uri.password = Experian.password
        uri.to_s
      end

      def excon_options
        Experian.proxy ? super.merge(proxy: Experian.proxy) : super
      end

    end
  end
end
