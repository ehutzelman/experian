module Experian
  module PreciseId
    class Response < Experian::Response
      def success?
        completion_code == "0000" && !precise_id_server_section.nil?
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

      def precise_id_server_section
        products_section["PreciseIDServer"]
      end

      def products_section
        @response["Products"]
      end

      def kba_section
        precise_id_server_section["KBA"]
      end
    end
  end
end
