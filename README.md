# Experian Ruby Gem

Ruby Wrapper for portions of the Experian Net Connect API. Experian exposes nearly 30 different services through the Net Connect API.
This gem currently only implements the Connect Check product (consumer credit scoring and identity validation), although
extending it to support the other products should be straightforward.

*Net Connect is a business-to-business application gateway designed to allow access to Experian legacy systems via the public
Internet or Experian’s private TCP/IP extranet transport. It is a secure 168-bit encrypted transaction, using HTTPS.
Net Connect is a non-browser-based system requiring Experian certified client or vendor software at the user's location.
It utilizes XML for the input inquiry and has the capability of returning field-level XML, as well as our standard Automated
Response Format (ARF) (computer readable), Teletype Response Format (TTY) (human readable) and Parallel Profile
(both ARF and TTY in one response). Net Connect meets the encryption standards requirement in the Safeguards section of the
Gramm- Leach-Bliley (GLB) Act.*

#### Net Connect Products

* Address Update
* Authentication Services
* BizID
* Bullseye
* Checkpoint - File One Verification Solution
* Collection Advantage interactive
* Collection Report
* **Connect Check (implemented in this gem)**
* Credit Profile
* Custom Solution
* Cross View
* CU Decision Expert
* Custom Strategist
* Decode
* Demographics
* Direct Check
* Employment Insight
* Fraud Shield
* Instant Prescreen
* New Consumer Identification
* Numeric Inquiry
* Parallel Profile
* Profile Summary
* Precise ID
* Precise ID Distributed
* Risk Models
* Social Search
* Truvue

## Installation

Add this line to your application's Gemfile:

    gem 'experian'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install experian

## Usage

### Configuration

Experian will provide you with the following authentication credentials when you sign up for their service:
```ruby
# Provide authentication credentials
Experian.configure do |config|
  config.eai = "X42PB93F"
  config.preamble = "FCD2"
  config.op_initials = "AB"
  config.subcode = "1968543"
  config.user = "user"
  config.password = "password"
  config.vendor_number = "P55"
end

# Route requests to Experian test server instead of production
Experian.test_mode = true

```

### Using a product client

Products are namespaced under the Experian module. Example of how to create a client for the Connect Check product:
```ruby
client = Experian::ConnectCheck::Client.new
```

Once you have a client, you can make requests:
```ruby
response = client.check_credit(first_name: "Homer", last_name: "Simpson", ssn: "123456789")

response.success?
# => true
response.completion_message
# => "Request processed successfully"
response.credit_match_code
# => "C"
response.credit_match_code_message
# => "ID Match"
response.credit_score
# => 846
response.customer_message
# => "Credit and ID have been verified and no deposit is required."
response.customer_names
# => ["HOMER J SIMPSON", "HOMER SIMPSON", "H SIMPSON", "PLOW KING"]
response.customer_addresses
# => ["96 JAMESTOWN BLVD  /HAMMONTON NJ 080372110",
# => "1466 BALLY BUNION DR  /EGG HARBOR CITY NJ 082155118",
# => "100 WEST LN  /HAMMONTON NJ 080371151"]
```

Alternatively, you can skip the explicit client instantiation and use the module level convenience method instead:
```ruby
response = Experian::ConnectCheck.check_credit(first_name: "Homer", last_name: "Simpson", ...)
```


### Handling errors from Experian
```ruby
response = client.check_credit(first_name: "Homer", last_name: "Simpson", ssn: "NaN")

response.success?
# => false
response.error_message
# => "Invalid request format"
response.error_action_indicator_message
# => "Correct and/or resubmit"
```

### Examine raw request and response XML
If you need to troubleshoot by viewing the raw XML, it is accesssible on the request and response objects of the client:
```ruby
# Inspect the request XML that was sent to Experian
client.request.xml
# => "<?xml version='1.0' encoding='utf-8'?>..."

# Inspect the response XML that was received from Experian
client.response.xml
# => "<?xml version='1.0' encoding='utf-8'?>..."
```

The meat of the Experian response is contained within the ```HostResponse``` XML element in the Automated Response
Format (ARF). The ruby wrapper for the response parses this ARF string into segments to determine the values we actually care about.

*The Automated Response Format (ARF) is a compressed, and/or abbreviated response in which a numeric value or an abbreviated
code is sent rather than the verbiage normally associated with Teletype report.*

```
client.response.host_response
# => "1100028100813165523TNJ10600@1110104SC 3XY  YXXXXXXX12AMBLE,ROBERT64Fraud alert on account. Deposit required to complete enrollment.@12500220603PRTBPPCTQQ@3220018 666153036@335006212ROBERT AMBLE1955A124ANNA                E61212261955@335002814ROBERT K AMBLE    @335002511KELLY AMBLE    @335003218ROBERT KELLY AMBLE    @3360074031308131003276502S        376717 11TH AVE  /BROOKLYN NY 112195904@..."
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012-2013 Eric Hutzelman.
See [LICENSE][] for details.

[license]: LICENSE.txt
