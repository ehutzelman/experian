require 'test_helper'

describe Experian::PreciseId::SecondaryRequest do

  let(:params) {{ session_id: 'test-session-id' }}

  it "creates a with all required fields" do
    request = Experian::PreciseId::SecondaryRequest.new(params)
    assert_equal fixture("precise_id", "secondary-request.xml"), request.xml
  end
  
end
