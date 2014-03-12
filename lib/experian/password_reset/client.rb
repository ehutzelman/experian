module Experian
  module PasswordReset
    class Client < Experian::Client

      def request_password
        @request = Request.new(command: 'requestnewpassword')
        @response = Response.new(submit_request)
      end

      def reset_password(new_password)
        @request = Request.new(new_password: new_password, command: 'resetpassword')
        @response = Response.new(submit_request)
        @response.success?
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
