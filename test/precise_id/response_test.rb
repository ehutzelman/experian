require 'test_helper'

describe Experian::PreciseId::Response do

  describe "successful response" do

    describe :all_responses do
      before do
        stub_experian_request("precise_id", "primary-response.xml")
        @request, @response = Experian::PreciseId.check_id(first_name: "Homer", last_name: "Simpson", ssn: "123456789")
      end

      it "receives a successful response" do
        assert @response.success?, "Response should be successful"
        refute @response.error?, "Response should not be an error"
      end

      it "extracts the session id" do
        assert_equal("03BE2482B0451905B5646883CED03D5D.pidd2v-1403070554290210020491121", @response.session_id)
      end

      it "extracts the initial decision" do
        assert_equal("ACC", @response.initial_decision)
      end

      it "extracts the final decision" do
        assert_equal("ACC", @response.final_decision)
      end
    end

    describe :kba_response do
      before do
        stub_experian_request("precise_id", "secondary-response.xml")
        @request,@response = Experian::PreciseId.request_questions(session_id: 'abc')
      end

      it "extracts the question set" do
        questions = [{
                       :type => 12,
                       :text => "I was born within a year or on the year of the date below.",
                       :choices => ["1947","1950","1953","1956","NONE OF THE ABOVE"]
                     },{
                       :type => 32,
                       :text => "According to your credit profile, you may have opened a mortgage loan in or around September 2011. Please select the lender to whom you currently make your mortgage payments. If you do not have a mortgage, select 'NONE OF THE ABOVE/DOES NOT APPLY'.",
                       :choices => ["INDEPENDENCE ONE","UNION BANK OF CALIFORNIA","ROCK FINANCIAL CORP","CROSSLAND MORTGAGE","NONE OF THE ABOVE/DOES NOT APPLY"]
                     },{
                       :type => 39,
                       :text => "Which of the following is a previous phone number of yours? If there is not a matched phone number, please select 'NONE OF THE ABOVE'.",
                       :choices => ["(626)216-3686","(626)227-2216","(626)207-1851","(626)206-7214","NONE OF THE ABOVE"]
                     },{
                       :type => 7,
                       :text => "You currently or previously resided on one of the following streets. Please select the street name from the following choices.",
                       :choices => ["NEWSON","GUENEVERE","PARKSIDE","WESTBEND","NONE OF THE ABOVE"]
        }]
        assert_equal(questions, @response.questions)
      end
    end


    describe :final_response do
      before do
        stub_experian_request("precise_id", "final-response.xml")
        @request, @response = Experian::PreciseId.send_answers(session_id: 'abc', answers: [1,2])
      end

      it "fetches the refer_code" do
        assert_equal "REF", @response.accept_refer_code
      end
    end

    describe "malformed response" do
      before do
        stub_experian_request("precise_id", "malformed-response.xml")
        @request, @response = Experian::PreciseId.check_id
      end

      it "reports an error" do
        refute @response.success?
        assert @response.error?        
      end
    end

    describe "precise_id error" do
      before do
        stub_experian_request("precise_id", "error-response.xml")
        @request, @response = Experian::PreciseId.check_id
      end

      it "reports an error" do
        refute @response.success?
        assert @response.error?
      end

      it "returns the error code" do
        assert_equal "010", @response.error_code
      end

      it "returns the error description" do
        assert_equal "Consumer is a minor", @response.error_message
      end
    end
  end

end
