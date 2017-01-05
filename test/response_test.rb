require 'test_helper'

describe Experian::Response do
  let(:response_body) { fixture("precise_id", "primary-response.xml") }
  let(:raw_response) { stub(status: 200, body: response_body, headers: {}) }

  subject { Experian::Response.new(raw_response) }

  it "recognises that the response was a success" do
    assert subject.success?
  end

  it "recognises that there were no errors" do
    refute subject.error?
  end

  it "returns an element" do
    element = subject.element_at("Experian/FraudSolutions/Response/Products/PreciseIDServer/Summary/CrossReferenceIndicatorsGrid/FullNameVerifiesToAddress")
    assert_equal "Match", element.text
    assert_equal "MA", element.attributes["code"]
  end

  it "returns nil if an element doesn't exist" do
    element = subject.element_at("Experian/Nothing")
    assert_equal element, nil
  end

  it "returns an array of elements" do
    array = subject.enum_at("Experian/FraudSolutions/Response/Products/PreciseIDServer/PreciseMatch/Addresses/Address/Detail/ResidentialAddressRcd/OtherHouseholdMembers/Name").collect { |n| n.text }
    assert_equal array, ["John", "Jane", "Sam"]
  end

  describe 'malformed xml' do
    let(:raw_response) { stub(status: 200, body: "malformed xml", headers: {}) }

    it "should raise a ClientError if response contains invalid xml" do
      e = assert_raises(Experian::ClientError) { subject }
      assert_equal raw_response, e.response
      assert_equal "Invalid xml response from Experian", e.message
    end
  end

  describe 'system error' do
    let(:response_body) { fixture("errors", "system-error.xml") }

    it "recognises that there has been an error" do
      assert subject.error?
    end

    it "recognises that the response was not a success" do
      refute subject.success?
    end

    it "extracts the completion code" do
      assert_equal "4000", subject.error_code
    end

    it "extracts the error message" do
      assert_equal "System error. Call Experian Technical Support at 1-800-854-7201.", subject.error_message
    end

    it "extracts the reference id" do
      assert_equal "userabc001", subject.reference_id
    end
  end

  describe 'format error' do
    let(:response_body) { fixture("errors", "format-error.xml") }

    it "recognises that there has been an error" do
      assert subject.error?
    end

    it "recognises that the response was not a success" do
      refute subject.success?
    end

    it "extracts the completion code" do
      assert_equal "1000", subject.error_code
    end

    it "extracts the error message" do
      assert_equal "Invalid Request Format", subject.error_message
    end

    it "extracts the reference id" do
      assert_nil subject.reference_id
    end
  end
end
