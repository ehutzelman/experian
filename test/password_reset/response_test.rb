require 'test_helper'

describe Experian::PasswordReset::Response do
  describe "successful response" do
    describe :all_responses do
      before do
        @response = Experian::PasswordReset::Response.new('dummy response')
      end

      it "receives a successful response" do
        assert @response.success?, "Response should be successful"
      end
    end
  end
end
