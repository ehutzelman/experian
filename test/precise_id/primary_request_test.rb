require 'test_helper'

describe Experian::PreciseId::PrimaryRequest do

  let(:params) {{
    first_name: 'Homer',
    last_name: 'Simpson',
    street: '742 Evergreen Terrace',
    city: 'Springfield',
    state: 'IL',
    zip: '60611'
  }}

  it "creates a with all required fields" do
    request = Experian::PreciseId::PrimaryRequest.new(params)
    assert_equal fixture("precise_id", "request.xml"), request.xml
  end

  it "should include verbose if it's passed in" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({
      :verbose => true
    }))
    assert_includes request.xml, "<Verbose>Y</Verbose>"
  end

  it "should include ReferenceNumber if it's passed in" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({
      :reference_number => "XML PROD OP 19"
    }))
    assert_includes request.xml, "<ReferenceNumber>XML PROD OP 19</ReferenceNumber>"
  end

  it "should include detail request if it's passed in" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({
      :detail_request => "D"
    }))
    assert_includes request.xml, "<DetailRequest>D</DetailRequest>"
  end

  it "should include inquiry channel if it's passed in" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({
      :inquiry_channel => "INTE"
    }))
    assert_includes request.xml, "<InquiryChannel>INTE</InquiryChannel>"
  end
end
