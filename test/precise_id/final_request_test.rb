require 'test_helper'

describe Experian::PreciseId::FinalRequest do

  let(:params) {{ 
    session_id: 'test-session-id',
    answers: [2,3,2,4]
  }}

  it "creates a with all required fields" do
    request = Experian::PreciseId::FinalRequest.new(params)
    assert_equal fixture("precise_id", "final-request.xml"), request.xml
  end
  
end
