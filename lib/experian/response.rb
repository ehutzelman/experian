require 'rexml/document'
require 'rexml/xpath'

module Experian
  class Response
    attr_reader :xml

    def initialize(raw_response)
      @raw_response = raw_response
      @xml = raw_response.body
      @doc = REXML::Document.new(@xml)
      validate
    end

    def success?
      !has_error?
    end

    def error?
      has_error?
    end

    def error_code
      completion_code
    end

    def reference_id
      value_at("NetConnectResponse/ReferenceId")
    end

    def error_message
      value_at("NetConnectResponse/ErrorMessage")
    end

    def value_at(path, parent = nil)
      e = element_at(path, parent)
      e.text if e
    end

    def element_at(path, parent = nil)
      REXML::XPath.first(parent || @doc, path)
    end

    def enum_at(path, parent = nil)
      REXML::XPath.each(parent || @doc, path)
    end

    private

    def validate
      raise Experian::ClientError.new(@raw_response), "Invalid xml response from Experian" unless @doc.has_elements?
    end

    def has_error?
      completion_code && completion_code != "0000"
    end

    def completion_code
      value_at("NetConnectResponse/CompletionCode")
    end
  end
end

