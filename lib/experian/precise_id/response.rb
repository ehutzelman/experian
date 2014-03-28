module Experian
  module PreciseId
    class Response < Experian::Response
      def success?
        super && has_precise_id_section? && !error?
      end

      def error?
        super || !has_precise_id_section? || has_error_section?
      end

      def error_code
        has_error_section? ? error_section["ErrorCode"] : nil
      end

      def error_message
        super || (has_error_section? ? error_section["ErrorDescription"] : nil)
      end

      def session_id
        precise_id_server_section["SessionID"]
      end

      def initial_decision
        initial_results_section["InitialDecision"]
      end

      def final_decision
        initial_results_section["FinalDecision"]
      end

      def accept_refer_code
        precise_id_server_section["KBAScore"]["ScoreSummary"]["AcceptReferCode"]
      end

      def questions
        return [] unless kba_section
        kba_section["QuestionSet"].collect do |question|
          {
            :type => question["QuestionType"].to_i,
            :text => question["QuestionText"],
            :choices => question["QuestionSelect"]["QuestionChoice"]
          }
        end
      end

      private

      def initial_results_section
        return nil unless has_summary_section?
        summary_section["InitialResults"]
      end

      def has_summary_section?
        !!summary_section
      end

      def summary_section
        return nil unless has_precise_id_section?
        precise_id_server_section["Summary"]
      end

      def has_precise_id_section?
        !!precise_id_server_section
      end

      def precise_id_server_section
        return nil unless has_products_section?
        products_section["PreciseIDServer"]
      end

      def has_products_section?
        !!products_section
      end

      def products_section
        @response["Products"]
      end

      def kba_section
        return nil unless has_precise_id_section?
        precise_id_server_section["KBA"]
      end

      def has_error_section?
        !!error_section
      end

      def error_section
        return nil unless has_precise_id_section?
        precise_id_server_section["Error"]
      end
    end
  end
end
