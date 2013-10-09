require 'test_helper'

describe Experian::Request do

  it "should build an xml NetConnect request container" do
    request = Experian::Request.new
    assert_match /<NetConnectRequest.*>\s<\/NetConnectRequest>/, request.xml
  end

end
