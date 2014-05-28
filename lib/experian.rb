require "excon"
require "builder"
require "experian/version"
require "experian/constants"
require "experian/error"
require "experian/client"
require "experian/request"
require "experian/response"
require "experian/connect_check"
require "experian/precise_id"
require "experian/password_reset"

module Experian
  include Experian::Constants

  class << self

    attr_accessor :eai, :preamble, :op_initials, :subcode, :user, :password, :vendor_number
    attr_accessor :test_mode, :proxy, :logger

    def configure
      yield self
    end

    def test_mode?
      !!test_mode
    end

    def ecals_uri
      uri = URI(Experian::LOOKUP_SERVLET_URL)
      uri.query = URI.encode_www_form(
        'lookupServiceName' => Experian::LOOKUP_SERVICE_NAME,
        'lookupServiceVersion' => Experian::LOOKUP_SERVICE_VERSION,
        'serviceName' => service_name,
        'serviceVersion' => Experian::SERVICE_VERSION,
        'responseType' => 'text/plain'
      )
      uri
    end

    def net_connect_uri
      perform_ecals_lookup if ecals_lookup_required?
      add_credentials(@net_connect_uri)
    end

    def precice_id_uri
      uri = URI.parse(test_mode? ? Experian::PRECISE_ID_TEST_URL : Experian::PRECISE_ID_URL)
      add_credentials(uri)
    end

    def add_credentials(uri)
      uri.tap do |u|
        u.user = Experian.user
        u.password = Experian.password
      end
    end

    def perform_ecals_lookup
      @net_connect_uri = URI.parse(Excon.get(ecals_uri.to_s).body)
      assert_experian_domain
      @ecals_last_update = Time.now
    rescue Excon::Errors::SocketError => e
      raise Experian::ClientError, "Could not connect to Experian: #{e.message}"
    end

    def ecals_lookup_required?
      @net_connect_uri.nil? || @ecals_last_update.nil? || Time.now - @ecals_last_update > Experian::ECALS_TIMEOUT
    end

    def assert_experian_domain
      unless @net_connect_uri.host.end_with?('.experian.com')
        @net_connect_uri = nil
        raise Experian::ClientError, "Could not authenticate connection to Experian, unexpected host name."
      end
    end

    def service_name
      test_mode? ? Experian::SERVICE_NAME_TEST : Experian::SERVICE_NAME
    end

  end
end
