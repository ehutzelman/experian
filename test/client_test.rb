require 'test_helper'

describe Experian::Client do
  let(:client) { Experian::Client.new }
  let(:request) { stub(body: "NETCONNECT_TRANSACTION=fake+xml+content", headers: {}) }
  let(:response) { stub(status: 200, headers:{}, body:"") }
  let(:excon) { stub(post: response) }

  describe 'initializing excon' do
    before do
      stub_experian_uri_lookup
    end

    it "includes the proxy in the excon arguments" do
      proxy = "http://proxy.example.com/"
      Experian.proxy = proxy
      Excon.expects(:new => excon).with('http://user:password@fake.experian.com',{idempotent:true,proxy:proxy})
      client.submit_request(request)
    end

    it "doesn't include the proxy if it's not provided" do
      Experian.proxy = nil
      Excon.expects(:new => excon).with('http://user:password@fake.experian.com',{idempotent:true})
      client.submit_request(request)
    end
  end

  describe 'stubbed excon' do
    before do
      client.stubs(:excon).returns excon
    end

    it "submits the request and return the raw response" do
      assert_equal response, client.submit_request(request)
    end

    describe 'connection error' do
      before do
        e = StandardError.new("An error message")
        excon.stubs(:post).raises(Excon::Errors::SocketError.new(e))
      end

      it "raises a client error" do
        assert_raises(Experian::ClientError) do
          client.submit_request(request)
        end
      end

      it "returns a message with the client error" do
        begin
          client.submit_request(request)
          flunk "Expected a client error"
        rescue Experian::ClientError => e
          assert_equal "Could not connect to Experian: An error message (StandardError)", e.message
        end
      end
    end

    describe 'forbidden error' do
      before do
        response.stubs(:headers).returns({ "Location" => "sso_logon" })
      end

      it "raises a forbidden exception if logon location header returned" do
        assert_raises(Experian::Forbidden) do
          client.submit_request(request)
        end
      end

      it "returns the raw response in the error" do
        begin
          client.submit_request(request)
          flunk "Expected a forbidden error"
        rescue Experian::Forbidden => e
          assert_equal response, e.response
        end
      end
    end

    describe '302 authentication error' do
      before do
        response.stubs(:status).returns 302
      end

      it "raises an AuthenticationError" do
        assert_raises(Experian::AuthenticationError) do
          client.submit_request(request)
        end
      end

      it "includes the raw response in the error" do
        begin
          client.submit_request(request)
          flunk "Expected an AuthenticationError"
        rescue Experian::AuthenticationError => e
          assert_equal response, e.response
        end
      end
    end

    describe '400 argument error' do
      before do
        response.stubs(:status).returns 400
      end

      it "raises an ArgumentError" do
        assert_raises(Experian::ArgumentError) do
          client.submit_request(request)
        end
      end

      it "includes the response in the error" do
        begin
          client.submit_request(request)
          flunk "Expected an ArgumentError"
        rescue Experian::ArgumentError => e
          assert_equal response, e.response
        end
      end

      it "provides an error message" do
        begin
          client.submit_request(request)
          flunk "Expected an ArgumentError"
        rescue Experian::ArgumentError => e
          assert_equal "Input parameter is missing or invalid", e.message
        end
      end
    end

    describe '403 unauthorized error' do
      before do
        response.stubs(:status).returns 403
      end

      it "raises an UnauthorizedError if we receive a 403" do
        assert_raises(Experian::Forbidden) do
          client.submit_request(request)
        end
      end

      it "includes the response in the error" do
        begin
          client.submit_request(request)
          flunk "Expected forbidden error"
        rescue Experian::Forbidden => e
          assert_equal response, e.response
        end
      end
    end

    describe '400 client error' do
      before do
        response.stubs(:status).returns 400
      end

      it "raises a ServerError if we receive a 404" do
        assert_raises(Experian::ClientError) do
          client.submit_request(request)
        end
      end

      it "includes the response in the error" do
        begin
          client.submit_request(request)
          flunk "Expected client error"
        rescue Experian::ClientError => e
          assert_equal response, e.response
        end
      end
    end

    describe '4** client error' do
      before do
        response.stubs(:status).returns 429
      end

      it "raises a general ClientError if we receive any kind of 4**" do
        assert_raises(Experian::ClientError) do
          client.submit_request(request)
        end
      end

      it "includes the response in the error" do
        begin
          client.submit_request(request)
          flunk "Expected client error"
        rescue Experian::ClientError => e
          assert_equal response, e.response
        end
      end
    end

    describe '500 client error' do
      before do
        response.stubs(:status).returns 500
      end

      it "raises a ServerError if we receive a 500" do
        assert_raises(Experian::ServerError) do
          client.submit_request(request)
        end
      end

      it "includes the response in the error" do
        begin
          client.submit_request(request)
          flunk "Expected server error"
        rescue Experian::ServerError => e
          assert_equal response, e.response
        end
      end
    end

    describe '5** client error' do
      before do
        response.stubs(:status).returns 503
      end

      it "should rase a general Server Error if we receive any other kind of 500" do
        assert_raises(Experian::ServerError) do
          client.submit_request(request)
        end
      end

      it "includes the response in the error" do
        begin
          client.submit_request(request)
          flunk "Expected server error"
        rescue Experian::ServerError => e
          assert_equal response, e.response
        end
      end
    end
  end
end
