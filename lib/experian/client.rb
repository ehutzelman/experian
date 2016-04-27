module Experian
  class Client

    def submit_request(request)
      response = post_request(request)
      validate_response(response)
    rescue Excon::Errors::SocketError => e
      raise Experian::ClientError.new(nil), "Could not connect to Experian: #{e.message}"
    end

    def validate_response(response)
      case response.status
      when 302
        # from docs:
        # Any of the following: Unauthorized user (this can occur due to an incorrect User ID and/or Password);
        # incorrect base64 encoding in the authorization header;
        # client did not open SSL socket/not using HTTPS;
        # MTU needs to be changed to 1492.
        raise Experian::AuthenticationError.new(response)
      when 400
        raise Experian::ArgumentError.new(response), "Input parameter is missing or invalid"
      when 403
        # Transaction was authenticated but not authorized.
        # The user ID may not have access to Precise ID XML Gateway product or it may be locked due to too
        # many password violations.
        raise Experian::Forbidden.new(response), "Access forbidden, please contact experian"
      when 400..499
        raise Experian::ClientError.new(response), "Response Code: #{response.status}"
      when 500..599
        raise Experian::ServerError.new(response), "Response Code: #{response.status}"
      else
        if !!(response.headers["Location"] =~ /sso_logon/)
          raise Experian::Forbidden.new(response), "Invalid Experian login credentials"
        else
          response
        end
      end
    end

    private

    def post_request(request)
      excon_class.
        new(request_uri.to_s, excon_options).
        post(body: request.body, headers: request.headers)
    end

    def excon_options
      {idempotent: true}.tap do |options|
        options[:proxy] = Experian.proxy if Experian.proxy
      end
    end

    def request_uri
      Experian.net_connect_uri
    end

    def excon_class
      Excon
    end
  end
end
