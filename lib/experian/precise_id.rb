require 'experian/precise_id/client'
require 'experian/precise_id/request'
require 'experian/precise_id/primary_request'
require 'experian/precise_id/secondary_request'
require 'experian/precise_id/response'

module Experian
  module PreciseId
    DB_HOST = "PRECISE_ID"
    DB_HOST_TEST = "PRECISE_ID_TEST"
    
    def self.db_host
      Experian.test_mode? ? DB_HOST_TEST : DB_HOST
    end

    # convenience method
    def self.check_id(options = {})
      Client.new.check_id(options)
    end

    def self.request_questions(options = {})
      Client.new.request_questions(options)
    end
  end
end
