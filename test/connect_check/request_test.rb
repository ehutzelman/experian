require 'test_helper'

describe Experian::ConnectCheck::Request do

  it "creates a request in xml format" do
    request = Experian::ConnectCheck::Request.new(
      first_name: 'Homer',
      last_name: 'Simpson',
      ssn: '123456789',
      reference_id: 'fakeReferenceId',
      street: '10655 NorthBirch Street',
      city: 'Springfield',
      state: 'IL',
      zip: '60611',
      yob: '1951',
      reference_number: '00234',
      end_user: 'homer'
    )

    assert_equal request.xml, fixture("connect_check", "request.xml")
  end

end
