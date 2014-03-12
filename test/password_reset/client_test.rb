require 'test_helper'

describe Experian::PasswordReset::Client do

  before do
    @client = Experian::PasswordReset::Client.new
  end

  describe "successful request" do
    before do
      stub_password_reset
    end

    it "performs a password request" do
      assert_kind_of Experian::PasswordReset::Response, @client.request_password
    end

    it "performs a password reset" do
      assert @client.reset_password('password')
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
