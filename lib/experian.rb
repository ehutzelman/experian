require "excon"
require "builder"
require "experian/version"
require "experian/constants"
require "experian/error"
require "experian/client"
require "experian/request"
require "experian/response"
require "experian/precise_id"
require "experian/password_reset"

module Experian
  include Experian::Constants

  class << self
    attr_accessor :preamble, :op_initials, :subcode, :user, :password, :vendor_number, :test_mode

    def configure
      yield self
    end

    def test_mode?
      !!test_mode
    end

    def precice_id_uri
      uri = URI.parse(test_mode? ? Experian::PRECISE_ID_TEST_URL : Experian::PRECISE_ID_URL)
      add_credentials(uri)
    end

    private

    def add_credentials(uri)
      uri.tap do |u|
        u.user = Experian.user
        u.password = Experian.password
      end
    end
  end
end
