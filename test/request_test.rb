require 'test_helper'

describe Experian::Request do

  before do
    @request = Experian::Request.new
  end

  it "instructs the xml before passing it off to subclasses" do
    assert_match /^<\?xml version="1\.0" encoding="utf-8"\?>.*/, @request.xml
  end

  it "should set the body to the url encoded request xml" do
    @request.stubs(:xml).returns("fake xml content")
    assert_equal "fake xml content", @request.body
  end

  it "should set the correct content type header" do
    assert_equal "text/xml", @request.headers["Content-Type"]
  end
end
