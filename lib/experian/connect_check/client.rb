module Experian
  module ConnectCheck
    class Client < Experian::Client
      def check_credit(options = {})
        assert_check_credit_options(options)
        Response.new(submit_request(Request.new(options)))
      end

      def assert_check_credit_options(options)
        return if options[:first_name] && options[:last_name] && options[:ssn]
        return if options[:first_name] && options[:last_name] && options[:street] && options[:zip]
        raise Experian::ArgumentError.new(nil), "Required options missing: first_name, last_name, ssn OR first_name, last_name, street, zip"
      end
    end
  end
end
