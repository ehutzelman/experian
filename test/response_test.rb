require 'test_helper'

describe Experian::Response do

  before do
    @response = Experian::Response.new(fixture("connect_check", "response.xml"))
  end

  it "should raise a ClientError if response contains invalid xml" do
    assert_raises(Experian::ClientError) do
      response = Experian::Response.new("malformed xml")
    end
  end

  it "extracts the host response" do
    refute_nil @response.host_response
  end

  it "extracts the error message" do
    response = Experian::Response.new(fixture("connect_check", "response_error.xml"))
    assert_equal "Invalid request format", response.error_message
  end

  it "extracts the completion code" do
    assert_equal "0000", @response.completion_code
  end

  it "extracts the transaction id" do
    assert_equal "8276972", @response.transaction_id
  end

  it "parses out defined segments into array" do
    assert_equal 22, @response.segments.count
  end

  it "returns a specific segment" do
    assert_equal "12500220603PRTBPPCTQQ", @response.segment(125)
  end

end
