require 'test_helper'

describe Experian::Request do

  before do
    @request = Experian::Request.new 
  end

  it "should build an xml NetConnect request container" do
    assert_match /<NetConnectRequest.*>\s<\/NetConnectRequest>/, @request.xml
  end

  it "should set the body to the url encoded request xml" do
    @request.stubs(:xml).returns("fake xml content")
    assert_equal "NETCONNECT_TRANSACTION=fake+xml+content", @request.body
  end

  it "should set the correct content type header" do
    assert_equal "application/x-www-form-urlencoded", @request.headers["Content-Type"]
  end
end
