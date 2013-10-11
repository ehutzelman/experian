require 'rexml/document'

module Experian
  class Response

      attr_reader :xml

      def initialize(xml)
        @xml = xml
        @response = parse_xml_response
      end

      def error_message
        @response["ErrorMessage"] || (Experian::Error.message(error_code) if error_code)
      end

      def host_response
        @response["HostResponse"]
      end

      def completion_code
        @response["CompletionCode"]
      end

      def completion_message
        Experian::COMPLETION_CODES[completion_code]
      end

      def transaction_id
        @response["TransactionId"]
      end

      def segments(segment_id = nil)
        @segments ||= host_response ? host_response.split("@") : []

        if segment_id
          @segments.select { |segment| segment.length >= 3 ? segment[0..2].to_i == segment_id : false }
        else
          @segments
        end
      end

      def segment(segment_id)
        segments(segment_id).first
      end

      def header_segment
        segment(110)
      end

      # error_segment returns the entire host response (segments 100, 200, 900)
      # since error responses do not separate segments with "@".
      def error_segment
        segment(100)
      end

      def success?
        completion_code == "0000" && !header_segment.nil?
      end

      def error?
        completion_code != "0000" || !error_segment.nil?
      end

      # The error message segment is embedded in the error segment :(
      def error_message_segment
        return unless error_segment
        error_segment[error_segment.index("200")..-1]
      end

      def error_code
        return unless error_segment
        error_message_segment[6..8].to_i
      end

      def error_action_indicator
        return unless error_segment
        error_message_segment[9]
      end

      def error_action_indicator_message
        Experian::ERROR_ACTION_INDICATORS[error_action_indicator]
      end

      private

      def parse_xml_response
        xml = REXML::Document.new(@xml)
        root = REXML::XPath.first(xml, "//NetConnectResponse")
        if root
          parse_element(root)
        else
          raise Experian::ClientError, "Invalid xml response from Experian"
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

  end
end

