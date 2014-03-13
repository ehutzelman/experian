require 'test_helper'

class MockResponse < Struct.new(:status, :headers, :body)
end

describe Experian::PasswordReset::Client do

  before do
    @client = Experian::PasswordReset::Client.new
    @raw_response = MockResponse.new(200,{'Response' => 'abc123'},"")
    @client.stubs(:post_request).returns(@raw_response)
  end

  describe "successful request" do
    before do
      stub_password_reset
    end

    it "performs a password request and returns password if it was successful" do
      assert_equal "abc123", @client.request_password
    end

    it "performs a password reset" do
      @raw_response.stubs(:headers).returns('Response' => "SUCCESS")
      assert_kind_of TrueClass, @client.reset_password('password')
    end

    it "returns false if the response wasn't success" do
      @raw_response.stubs(:headers).returns('Response' => "FAILURE")
      assert_kind_of FalseClass, @client.reset_password('password')      
    end

    it "includes the proxy in the excon arguments" do
      assert_includes @client.excon_options.keys, :proxy
      assert @client.excon_options[:proxy], 'http://example.com'
    end

    it "doesn't include the proxy if it's not provided" do
      Experian.stubs(:proxy).returns(nil)
      refute_includes @client.excon_options.keys, :proxy
    end
  end

end
