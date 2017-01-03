require 'rexml/document'

module Experian
  class Response
    attr_reader :xml

    def initialize(raw_response)
      @raw_response = raw_response
      @xml = raw_response.body
      @response = parse_xml_response
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
      hash_path(net_connect_section, "ReferenceId")
    end

    def error_message
      hash_path(net_connect_section, "ErrorMessage")
    end

    private

    def parse_xml_response
      doc = REXML::Document.new(@xml)
      if doc.has_elements?
        {doc.root.name => parse_element(doc.root)}
      else
        raise Experian::ClientError.new(@raw_response), "Invalid xml response from Experian"
      end
    end

    # parse xml node elements recursively into hash
    def parse_element(node)
      if node.has_elements?
        response = {}
        node.elements.each do |e|
          key = e.name
          value = parse_element(e)
          if response.has_key?(key)
            if response[key].is_a?(Array)
              response[key].push(value)
            else
              response[key] = [response[key], value]
            end
          else
            response[key] = parse_element(e)
          end
        end
      else
        response = node.text
      end
      response
    end

    def has_error?
      completion_code && completion_code != "0000"
    end

    def completion_code
      hash_path(net_connect_section, "CompletionCode")
    end

    def net_connect_section
      @net_connect_section ||= hash_path(@response, "NetConnectResponse")
    end

    def hash_path(hash, *path)
      return nil unless hash
      field = path[0]
      field_value = hash[field]

      if path.length == 1
        field_value
      else
        hash_path(field_value, *path[1..-1])
      end
    end
  end
end

