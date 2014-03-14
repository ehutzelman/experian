require 'test_helper'

describe Experian::Client do

  before do
    stub_experian_uri_lookup
    @client = Experian::Client.new
    @client.stubs(:request).returns(stub(body: "NETCONNECT_TRANSACTION=fake+xml+content", headers: {}))
  end

  it "submits the request and return the response body" do
    Excon::Connection.any_instance.expects(:post).returns(stub(body: "fake body content", headers: {},status:200))
    assert_equal "fake body content", @client.submit_request
  end

  it "raises a forbidden exception if logon location header returned" do
    Excon::Connection.any_instance.expects(:post).returns(stub(headers: { "Location" => "sso_logon" },status: 200))
    assert_raises(Experian::Forbidden) do
      @client.submit_request
    end
  end

  it "raises an AuthenticationError if we receive a 302" do
    stub_experian_request('connect_check','request.xml', 302)
    assert_raises(Experian::AuthenticationError) do
      @client.submit_request
    end
  end

  it "raises an ArgumentError if we receive a 400" do
    stub_experian_request('connect_check','request.xml', 400)
    assert_raises(Experian::ArgumentError) do
      @client.submit_request
    end
  end

  it "provides details if we receive a 400" do
    stub_experian_request('connect_check','request.xml', 400)
    begin
      @client.submit_request
    rescue Experian::ArgumentError => e
      assert_equal "Input parameter is missing or invalid", e.message
    end
  end

  it "raises an UnauthorizedError if we receive a 403" do
    stub_experian_request('connect_check','request.xml', 403)
    assert_raises(Experian::Forbidden) do
      @client.submit_request
    end
  end

  it "raises a ServerError if we receive a 404" do
    stub_experian_request('connect_check','request.xml', 404)
    assert_raises(Experian::ClientError) do
      @client.submit_request
    end    
  end

  it "raises a general ClientError if we receive any kind of 4**" do
    stub_experian_request('connect_check','request.xml', 429)
    assert_raises(Experian::ClientError) do
      @client.submit_request
    end    
  end

  it "raises a ServerError if we receive a 500" do
    stub_experian_request('connect_check','request.xml', 500)
    assert_raises(Experian::ServerError) do
      @client.submit_request
    end
  end

  it "should rase a general Server Error if we receive any other kind of 500" do
    stub_experian_request('connect_check','request.xml', 503)
    assert_raises(Experian::ServerError) do
      @client.submit_request
    end
  end

end
