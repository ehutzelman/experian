require 'test_helper'

describe Experian::PasswordReset::Request do

  let(:params) {{new_password: 'password',command: 'resetpassword'}}

  it "creates a request with all required fields" do
    request = Experian::PasswordReset::Request.new(params)
    assert_equal "&application=xmlgateway&command=resetpassword&newpassword=password", request.body
  end

end
