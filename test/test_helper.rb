require 'experian'
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'
require 'mocha/setup'
require 'timecop'

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(product, file)
  File.read("#{fixture_path}/#{product}/#{file}")
end

def stub_experian_request(product, file, status = 200)
  stub_request(:post, "http://user:password@fake.experian.com").to_return(body: fixture(product, file), status: status)
  stub_request(:post, "https://user:password@dm-sgw1.experian.com/fraudsolutions/xmlgateway/preciseid").to_return(body: fixture(product, file), status: status)
end

def stub_password_reset(status = 200)
  stub_request(:post, "https://user:password@ss3.experian.com/securecontrol/reset/passwordreset").
    to_return(:status => status, :body => "", :headers => {})
end

Experian.configure do |config|
  config.preamble = "FCD2"
  config.op_initials = "AB"
  config.subcode = "1968543"
  config.user = "user"
  config.password = "password"
  config.vendor_number = "P55"
  config.test_mode = true
end
