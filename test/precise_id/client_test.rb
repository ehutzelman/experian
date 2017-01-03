require 'test_helper'

describe Experian::PreciseId::Client do
  before do
    @client = Experian::PreciseId::Client.new
    stub_experian_request("precise_id", "primary-response.xml")
  end

  it "performs a precise id check" do
    request,response = @client.check_id
    assert_kind_of Experian::PreciseId::PrimaryRequest, request
    assert_kind_of Experian::PreciseId::Response, response
  end
end
