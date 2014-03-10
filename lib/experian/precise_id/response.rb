module Experian
  module PreciseId
    class Response < Experian::Response
      def success?
        completion_code == "0000" && has_precise_id_section? && !error?
      end

      def error?
        completion_code != "0000" || !has_precise_id_section? || has_error_section?
      end

      def error_code
        error_section["ErrorCode"]
      end

      def error_message
        error_section["ErrorDescription"] || super
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
        summary_section["InitialResults"]
      end

      def summary_section
        precise_id_server_section["Summary"]
      end

      def has_precise_id_section?
        !!products_section["PreciseIDServer"]
      end

      def precise_id_server_section
        products_section["PreciseIDServer"]
      end

      def products_section
        @response["Products"]
      end

      def kba_section
        precise_id_server_section["KBA"]
      end

      def has_error_section?
        !!error_section
      end

      def error_section
        precise_id_server_section["Error"]
      end
    end
  end
end
