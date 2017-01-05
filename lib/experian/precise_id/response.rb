module Experian
  module PreciseId
    class Response < Experian::Response
      PRECISE_ID_SERVER_PATH = "Experian/FraudSolutions/Response/Products/PreciseIDServer"

      def error_code
        super || value_at(PRECISE_ID_SERVER_PATH + "/Error/ErrorCode")
      end

      def error_message
        super || value_at(PRECISE_ID_SERVER_PATH + "/Error/ErrorDescription")
      end

      def session_id
        value_at(PRECISE_ID_SERVER_PATH + "/SessionID")
      end

      def initial_decision
        value_at(PRECISE_ID_SERVER_PATH + "/Summary/InitialDecision")
      end

      def final_decision
        value_at(PRECISE_ID_SERVER_PATH + "/Summary/FinalDecision")
      end

      def accept_refer_code
        value_at(PRECISE_ID_SERVER_PATH + "/KBAScore/ScoreSummary/AcceptReferCode")
      end

      def questions
        questions = enum_at(PRECISE_ID_SERVER_PATH +  "/KBA/QuestionSet")
        questions.collect do |question|
          {
            :type => value_at("QuestionType", question).to_i,
            :text => value_at("QuestionText", question),
            :choices => enum_at("QuestionSelect/QuestionChoice", question).collect { |c| c.text }
          }
        end
      end

      private

      def precise_id_section?
        !!element_at(PRECISE_ID_SERVER_PATH)
      end

      def has_error?
        super || precise_id_error_section? || !precise_id_section?
      end

      def precise_id_error_section?
        !!element_at(PRECISE_ID_SERVER_PATH + "/Error")
      end

      def precise_id_server
        value_at(PRECISE_ID_SERVER_PATH)
      end
    end
  end
end
