module Experian
  class Client

    attr_reader :request, :response

    def submit_request
      connection = Excon.new(Experian.net_connect_uri.to_s, idempotent: true)
      @raw_response = connection.post(body: request_body, headers: request_headers)
      raise Experian::Forbidden, "Invalid Experian login credentials" if invalid_login?
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

    def invalid_login?
      !!(@raw_response.headers["Location"] =~ /sso_logon/)
    end

  end
end
