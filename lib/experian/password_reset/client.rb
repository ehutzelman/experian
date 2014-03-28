module Experian
  module PasswordReset
    class Client < Experian::Client

      SUCCESS_RESPONSE = "SUCCESS"

      def request_password
        request = Request.new(command: 'requestnewpassword')
        response = submit_request(request)
        response.headers["Response"]
      end

      def reset_password(new_password)
        request = Request.new(new_password: new_password, command: 'resetpassword')
        response = submit_request(request)
        response.headers["Response"] == SUCCESS_RESPONSE
      end

      def request_uri
        # setup basic authentication
        URI.parse(Experian::Constants::PASSWORD_RESET_URL).tap do |u|
          u.user = Experian.user
          u.password = Experian.password
        end
      end

      def excon_options
        Experian.proxy ? super.merge(proxy: Experian.proxy) : super
      end

    end
  end
end
