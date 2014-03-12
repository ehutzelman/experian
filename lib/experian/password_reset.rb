require 'experian/password_reset/client'
require 'experian/password_reset/request'
require 'experian/password_reset/response'

module Experian
  module PasswordReset
    # convenience method
    def self.reset_password(new_password)
      Client.new.reset_password(new_password)
    end
  end
end
