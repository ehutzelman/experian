module Experian
  module ConnectCheck
    class Response < Experian::Response

      def success?
        super && !header_segment.nil?
      end

      def input_type
        return unless connect_check_segment
        connect_check_segment[7]
      end

      def credit_match_code
        return unless connect_check_segment
        connect_check_segment[8]
      end

      def credit_match_code_message
        MATCH_CODES[credit_match_code]
      end

      def credit_class_code
        return unless connect_check_segment
        connect_check_segment[10]
      end

      def credit_score
        return unless risk_score_segment
        risk_score_segment[7..10].to_i
      end

      def high_risk_address_alert
        return unless connect_check_segment
        connect_check_segment[11]
      end

      def credit_fraud_code
        case statement_type_code
        when 25 then 'X' # file frozen due to state legislation
        when 26..31 then 'Y' # active credit alerts
        else 'Z' # assume no fraud
        end if success?
      end

      def statement_type_code
        return unless consumer_statement_segment
        consumer_statement_segment[7..8].to_i
      end

      def customer_name_length
        return unless connect_check_segment
        connect_check_segment[23..25].to_i
      end

      def customer_name
        return unless connect_check_segment
        connect_check_segment[25, customer_name_length]
      end

      def customer_names
        segments(335).map do |segment|
          segment[9, segment[7..8].to_i]
        end
      end

      def customer_addresses
        segments(336).map do |segment|
          segment[36, segment[34..35].to_i]
        end
      end

      def customer_message_length
        return unless connect_check_segment
        connect_check_segment[25 + customer_name_length, 2].to_i
      end

      def customer_message
        return unless connect_check_segment
        connect_check_segment[25 + customer_name_length + 2, customer_message_length]
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

      def error?
        super || !error_segment.nil?
      end

      def error_code
        return unless error_segment
        error_message_segment[6..8].to_i
      end

      def error_message
        super || (Experian::Error.message(error_code) if error_code)
      end

      def error_action_indicator
        return unless error_segment
        error_message_segment[9]
      end

      private

      def header_segment
        segment(110)
      end

      def consumer_statement_segment
        segment(365)
      end

      def connect_check_segment
        segment(111)
      end

      def risk_score_segment
        segment(125)
      end

      # error_segment returns the entire host response (segments 100, 200, 900)
      # since error responses do not separate segments with "@".
      def error_segment
        segment(100)
      end

      # The error message segment is embedded in the error segment :(
      def error_message_segment
        return unless error_segment
        error_segment[error_segment.index("200")..-1]
      end

    end
  end
end
