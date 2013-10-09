require 'experian/connect_check/client'
require 'experian/connect_check/request'
require 'experian/connect_check/response'

module Experian
  module ConnectCheck

    MATCH_CODES = {
      "A" => "Deceased/Non-Issued Social Security Number",
      "B" => "No Record Found",
      "C" => "ID Match",
      "D" => "ID Match to Other Name",
      "E" => "ID No Match"
    }

    DB_HOST = "CIS"
    DB_HOST_TEST = "STAR"

    def self.db_host
      Experian.test_mode? ? DB_HOST_TEST : DB_HOST
    end

    # convenience method
    def self.check_credit(options = {})
      Client.new.check_credit(options)
    end

  end
end
