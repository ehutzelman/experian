module Experian
  class Client

    attr_reader :request, :response, :raw_response

    def submit_request
      @raw_response = post_request
      validate_response
      @raw_response.body

    rescue Excon::Errors::SocketError => e
      raise Experian::ClientError, "Could not connect to Experian: #{e.message}"
    end

    def validate_response
      case @raw_response.status
      when 302
        # from docs:
        # Any of the following: Unauthorized user (this can occur due to an incorrect User ID and/or Password);
        # incorrect base64 encoding in the authorization header;
        # client did not open SSL socket/not using HTTPS;
        # MTU needs to be changed to 1492.
        raise Experian::AuthenticationError
      when 400
        raise Experian::ArgumentError
      when 403
        # Transaction was authenticated but not authorized.
        # The user ID may not have access to Precise ID XML Gateway product or it may be locked due to too 
        # many password violations.
        raise Experian::Forbidden, "Access forbidden, please contact experian"
      when 404
        raise Experian::ServerError, "Experian not found"
      when 500
        raise Experian::ServerError, "Experian server error"
      else
        raise Experian::Forbidden, "Invalid Experian login credentials" if !!(@raw_response.headers["Location"] =~ /sso_logon/)
      end
    end

    private

    def post_request
      connection = Excon.new(request_uri.to_s, excon_options)
      connection.post(body: request.body, headers: request.headers)
    end

    def excon_options
      {idempotent: true}
    end

    def request_uri
      Experian.net_connect_uri
    end

  end
end
