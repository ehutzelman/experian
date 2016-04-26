require 'test_helper'

describe Experian::ConnectCheck::Client do

  before do
    @client = Experian::ConnectCheck::Client.new
  end

  it "should perform a credit check" do
    stub_experian_request("connect_check", "response.xml")
    assert_kind_of Experian::ConnectCheck::Response,
      @client.check_credit(first_name: "Homer", last_name: "Simpson", ssn: "123456789")
  end

  describe 'argument error' do
    it "should raise an ArgumentError if passed bad arguments" do
      assert_raises(Experian::ArgumentError) do
        @client.assert_check_credit_options({})
      end
    end

    it "returns a message with the error" do
      begin
        @client.assert_check_credit_options({})
        flunk "expected argument error"
      rescue Experian::ArgumentError => e
        assert_equal "Required options missing: first_name, last_name, ssn OR first_name, last_name, street, zip", e.message
      end
    end
  end
end
