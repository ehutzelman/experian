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
    assert_equal fixture("precise_id", "primary-request.xml"), request.xml
  end

  it "includes date of birth if it's included" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({ :dob => "1231990" }))
    assert_includes request.xml, "<DOB>1231990</DOB>"
  end

  it "includes phone number if it is provided" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({ :phone => "12345" }))
    assert_match %r{<Phone>\s*<Number>12345</Number>\s*</Phone>}, request.xml
  end

  it "includes email if it's included" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({ :email => "bob@example.com" }))
    assert_includes request.xml, "<EmailAddress>bob@example.com</EmailAddress>"
  end

  it "includes ip address if it's included" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({ :ip_address => "123.1234.231.23" }))
    assert_includes request.xml, "<IPAddress>123.1234.231.23</IPAddress>"
  end

  it "includes verbose if it's passed in" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({ :verbose => true }))
    assert_includes request.xml, "<Verbose>Y</Verbose>"
  end

  it "includes ReferenceNumber if it's passed in" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({
      :reference_number => "XML PROD OP 19"
    }))
    assert_includes request.xml, "<ReferenceNumber>XML PROD OP 19</ReferenceNumber>"
  end

  it "includes detail request if it's passed in" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({
      :detail_request => "D"
    }))
    assert_includes request.xml, "<DetailRequest>D</DetailRequest>"
  end

  it "includes inquiry channel if it's passed in" do
    request = Experian::PreciseId::PrimaryRequest.new(params.merge({
      :inquiry_channel => "INTE"
    }))
    assert_includes request.xml, "<InquiryChannel>INTE</InquiryChannel>"
  end

end
