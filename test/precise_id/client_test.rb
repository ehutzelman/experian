require 'test_helper'

describe Experian::PreciseId::Client do

  before do
    @client = Experian::PreciseId::Client.new
  end

  it "should perform a precise id check" do
    stub_experian_request("precise_id", "response.xml")
    assert_kind_of Experian::PreciseId::Response, @client.check_id
  end

  it "should perform a secondary inquiry" do
    stub_experian_request("precise_id", "response.xml")
    assert_kind_of Experian::PreciseId::Response, @client.request_questions
  end

end
