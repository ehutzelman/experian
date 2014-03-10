require 'test_helper'

describe Experian::Client do

  before do
    stub_experian_uri_lookup
    @client = Experian::Client.new
    @client.stubs(:request).returns(stub(xml: "fake xml content"))
  end

  it "should submit the request and return the response body" do
    Excon::Connection.any_instance.expects(:post).returns(stub(body: "fake body content", headers: {},status:200))
    assert_equal "fake body content", @client.submit_request
  end

  it "should set the correct content type header" do
    assert_equal "application/x-www-form-urlencoded", @client.request_headers["Content-Type"]
  end

  it "should set the body to the url encoded request xml" do
    assert_equal "NETCONNECT_TRANSACTION=fake+xml+content", @client.request_body
  end

  it "should raise a forbidden exception if logon location header returned" do
    Excon::Connection.any_instance.expects(:post).returns(stub(headers: { "Location" => "sso_logon" },status: 200))
    assert_raises(Experian::Forbidden) do
      @client.submit_request
    end
  end

end
