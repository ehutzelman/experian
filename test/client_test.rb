require 'test_helper'

describe Experian::Client do

  before do
    stub_experian_uri_lookup

    @logger = Experian.logger = stub(info: nil, error: nil)
    @client = Experian::Client.new
    @request = stub(body: "NETCONNECT_TRANSACTION=fake+xml+content", headers: {})
    @response = stub(status: 200,headers:{},body:"")
    @excon = stub(post:@response)
  end

  it "submits the request and return the raw response" do
    response = stub(body: "fake body content", headers: {},status:200)
    @client.stubs(:post_request).returns(response)
    assert_equal response, @client.submit_request(@request)
  end

  it "includes the proxy in the excon arguments" do
    proxy = "http://proxy.example.com/"
    Experian.stubs(:proxy).returns(proxy)
    Excon.expects(:new => @excon).with('http://user:password@fake.experian.com',{idempotent:true,proxy:proxy})
    @client.submit_request(@request)
  end

  it "doesn't include the proxy if it's not provided" do
    Experian.stubs(:proxy).returns(nil)
    Excon.expects(:new => @excon).with('http://user:password@fake.experian.com',{idempotent:true})
    @client.submit_request(@request)
  end

  it "raises a forbidden exception if logon location header returned" do
    @client.stubs(:post_request).returns(stub(headers: { "Location" => "sso_logon" },status: 200))
    assert_raises(Experian::Forbidden) do
      @client.submit_request(@request)
    end
  end

  it "logs the raw response if an error is thrown" do
    response = stub(headers: { "Location" => "sso_logon" },status: 200)
    @client.stubs(:post_request).returns(response)
    @logger.expects(:error).with("Experian Error Detected, Raw response: #{response.inspect}")
    assert_raises(Experian::Forbidden) do
      @client.submit_request(@request)
    end
  end

  it "raises an AuthenticationError if we receive a 302" do
    stub_experian_request('connect_check','request.xml', 302)
    assert_raises(Experian::AuthenticationError) do
      @client.submit_request(@request)
    end
  end

  it "raises an ArgumentError if we receive a 400" do
    stub_experian_request('connect_check','request.xml', 400)
    assert_raises(Experian::ArgumentError) do
      @client.submit_request(@request)
    end
  end

  it "provides details if we receive a 400" do
    stub_experian_request('connect_check','request.xml', 400)
    begin
      @client.submit_request(@request)
    rescue Experian::ArgumentError => e
      assert_equal "Input parameter is missing or invalid", e.message
    end
  end

  it "raises an UnauthorizedError if we receive a 403" do
    stub_experian_request('connect_check','request.xml', 403)
    assert_raises(Experian::Forbidden) do
      @client.submit_request(@request)
    end
  end

  it "raises a ServerError if we receive a 404" do
    stub_experian_request('connect_check','request.xml', 404)
    assert_raises(Experian::ClientError) do
      @client.submit_request(@request)
    end
  end

  it "raises a general ClientError if we receive any kind of 4**" do
    stub_experian_request('connect_check','request.xml', 429)
    assert_raises(Experian::ClientError) do
      @client.submit_request(@request)
    end
  end

  it "raises a ServerError if we receive a 500" do
    stub_experian_request('connect_check','request.xml', 500)
    assert_raises(Experian::ServerError) do
      @client.submit_request(@request)
    end
  end

  it "should rase a general Server Error if we receive any other kind of 500" do
    stub_experian_request('connect_check','request.xml', 503)
    assert_raises(Experian::ServerError) do
      @client.submit_request(@request)
    end
  end

end
