require 'test_helper'

describe Experian::Response do
  let(:response_body) { fixture("connect_check", "response.xml") }
  let(:raw_response) { stub(status: 200, body: response_body, headers: {}) }
  subject { Experian::Response.new(raw_response) }

  describe 'client error' do
    let(:raw_response) { stub(status: 200, body: "malformed xml", headers: {}) }

    it "should raise a ClientError if response contains invalid xml" do
      assert_raises(Experian::ClientError) do
        subject
      end
    end

    it "includes the raw response" do
      begin
        subject
        flunk "Expected client error"
      rescue Experian::ClientError => e
        assert_equal raw_response, e.response
      end
    end

    it "includes an error message" do
      begin
        subject
        flunk "Expected client error"
      rescue Experian::ClientError => e
        assert_equal "Invalid xml response from Experian", e.message
      end
    end
  end

  it "extracts the host response" do
    refute_nil subject.host_response
  end

  it "extracts the completion code" do
    assert_equal "0000", subject.completion_code
  end

  it "extracts the transaction id" do
    assert_equal "8276972", subject.transaction_id
  end

  describe 'error fields' do
    let(:response_body) { fixture("connect_check", "response_error.xml") }

    it "extracts the error message" do
      assert_equal "Invalid request format", subject.error_message
    end

    it "extracts the tag" do
      assert_equal "NetConnectRequest/Request/Products/ConnectCheck/PrimaryApplicant/ConnectCheck_PrimaryApplicantTypeChoice/null", subject.error_tag
    end
  end
end
