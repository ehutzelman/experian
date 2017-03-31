module Experian
  module PasswordReset
    class Request < Experian::Request

      def initialize(options = {})
        @options = options
      end

      def body
        "&#{encode_params}"
      end

      def headers
        { "Content-Type" => "application/x-www-form-urlencoded" }
      end

      private

      def encode_params
        params = {
          :application => 'xmlgateway',
          :command => @options[:command]
        }

        params[:newpassword] = @options[:new_password] if @options[:new_password]

        URI.encode_www_form(params)
      end

    end
  end
end
