module Experian
  class Client

    attr_reader :request, :response

    def submit_request
      connection = Excon.new(Experian.net_connect_uri.to_s, idempotent: true)
      @raw_response = connection.post(body: request_body, headers: request_headers)
      validate_response
      @raw_response.body

    rescue Excon::Errors::SocketError => e
      raise Experian::ClientError, "Could not connect to Experian: #{e.message}"
    end

    def request_body
      URI.encode_www_form('NETCONNECT_TRANSACTION' => request.xml)
    end

    def request_headers
      { "Content-Type" => "application/x-www-form-urlencoded" }
    end

    def validate_response
      case @raw_response.status
      when 302
        # from docs:
        # Any of the following: Unauthorized user (this can occur due to an incorrect User ID and/or Password);
        # incorrect base64 encoding in the authorization header;
        # client did not open SSL socket/not using HTTPS;
        # MTU needs to be changed to 1492.
        raise Experian::Forbidden, "Authorization failed"
      when 403
        # Transaction was authenticated but not authorized.
        # The user ID may not have access to Precise ID XML Gateway product or it may be locked due to too 
        # many password violations.
        raise Experian::Forbidden, "Access forbidden"
      when 404
        raise Experian::ServerError, "Experian not available"
      else
        raise Experian::Forbidden, "Invalid Experian login credentials" if !!(@raw_response.headers["Location"] =~ /sso_logon/)
      end
    end

  end
end
