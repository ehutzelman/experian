require 'test_helper'

describe Experian::Response do

  before do
    @response = Experian::Response.new(fixture("connect_check", "response.xml"))
  end

  describe 'client error' do
    it "should raise a ClientError if response contains invalid xml" do
      assert_raises(Experian::ClientError) do
        response = Experian::Response.new("malformed xml")
      end
    end

    it "includes an error message" do
      begin
        response = Experian::Response.new("malformed xml")
        flunk "Expected client error"
      rescue Experian::ClientError => e
        assert_equal "Invalid xml response from Experian", e.message
      end
    end
  end

  it "extracts the host response" do
    refute_nil @response.host_response
  end

  it "extracts the completion code" do
    assert_equal "0000", @response.completion_code
  end

  it "extracts the transaction id" do
    assert_equal "8276972", @response.transaction_id
  end

  describe 'error fields' do
    before do
      @response = Experian::Response.new(fixture("connect_check", "response_error.xml"))
    end

    it "extracts the error message" do
      assert_equal "Invalid request format", @response.error_message
    end

    it "extracts the tag" do
      assert_equal "NetConnectRequest/Request/Products/ConnectCheck/PrimaryApplicant/ConnectCheck_PrimaryApplicantTypeChoice/null", @response.error_tag
    end
  end

end
