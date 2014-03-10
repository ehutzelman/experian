require 'test_helper'

describe Experian::PreciseId::Client do

  before do
    @client = Experian::PreciseId::Client.new
  end

  describe "successful request" do
    before do
      stub_experian_request("precise_id", "primary-response.xml")
    end

    it "performs a precise id check" do
      assert_kind_of Experian::PreciseId::Response, @client.check_id
    end
  
    it "performs a secondary inquiry" do
      assert_kind_of Experian::PreciseId::Response, @client.request_questions
    end
  
    it "performs a final inquiry" do
      assert_kind_of Experian::PreciseId::Response, @client.send_answers
    end
  end

  describe "unsuccessful request" do
  
    it "should handle a 302 as authentication failed" do
      stub_experian_request("precise_id", "empty-response.xml", 302)
      assert_raises(Experian::Forbidden) { @client.check_id }
    end

    it "should handle a 403 as unauthorized" do
      stub_experian_request("precise_id", "empty-response.xml", 403)
      assert_raises(Experian::Forbidden) { @client.check_id }
    end

    it "should handle a 404 as gateway unavailable" do
      stub_experian_request("precise_id", "empty-response.xml", 404)
      assert_raises(Experian::ServerError) { @client.check_id }
    end
  end
end
