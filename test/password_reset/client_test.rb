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

    it "applies the username and password to the request_uri" do
      request_uri = @client.request_uri
      assert_equal "user", request_uri.user
      assert_equal "password", request_uri.password
    end

    it "returns false if the response wasn't success" do
      @raw_response.stubs(:headers).returns('Response' => "FAILURE")
      assert_kind_of FalseClass, @client.reset_password('password')
    end

  end

end
