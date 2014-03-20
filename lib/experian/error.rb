module Experian
  class Error < StandardError

    def self.message(code)
      "Experian: " + (codes[code] || "Error Code #{code}")
    end

    # Experian has hundreds of codes documented, only populated small set
    def self.codes
      {
        1 => "System temporarily unavailable. Please resubmit",
        53 => "Invalid social security number"
      }
    end
  end

  class ClientError < Error; end
  class ArgumentError < ClientError; end
  class Forbidden < ClientError; end
  class ServerError < Error; end
  class AuthenticationError < Error; end

end
