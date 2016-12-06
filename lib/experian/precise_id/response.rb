module Experian
  module PreciseId
    class Response < Experian::Response
      def success?
        super && has_precise_id_section?
      end

      def error_code
        super || hash_path(precise_id_error_section, "ErrorCode")
      end

      def error_message
        super || hash_path(precise_id_error_section, "ErrorDescription")
      end

      def session_id
        hash_path(precise_id_server, "SessionID")
      end

      def initial_decision
        hash_path(summary, "InitialDecision")
      end

      def final_decision
        hash_path(summary, "FinalDecision")
      end

      def accept_refer_code
        hash_path(precise_id_server,"KBAScore","ScoreSummary","AcceptReferCode")
      end

      def questions
        questions = hash_path(precise_id_server, "KBA", "QuestionSet")
        if questions
          questions.collect do |question|
            {
              :type => question["QuestionType"].to_i,
              :text => question["QuestionText"],
              :choices => question["QuestionSelect"]["QuestionChoice"]
            }
          end
        else
          []
        end
      end

      private

      def has_precise_id_section?
        !!precise_id_server
      end

      def has_error_section?
        super || !!precise_id_error_section
      end

      def precise_id_error_section
        hash_path(precise_id_server,"Error")
      end

      def summary
        @summary ||= hash_path(precise_id_server, "Summary")
      end

      def precise_id_server
        @precise_id_server ||= hash_path(@response, "Experian", "FraudSolutions", "Response", "Products", "PreciseIDServer")
      end
    end
  end
end
