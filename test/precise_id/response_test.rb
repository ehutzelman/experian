require 'test_helper'

describe Experian::PreciseId::Response do

  describe "successful response" do
    before do
      stub_experian_request("precise_id", "response.xml")
      @response = Experian::PreciseId.check_id(first_name: "Homer", last_name: "Simpson", ssn: "123456789")
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

end
