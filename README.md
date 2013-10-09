# Experian

Ruby Wrapper for the Experian Net Connect API.

Net Connect is a business-to-business application gateway designed to allow access to Experian legacy systems via the public
Internet or Experian’s private TCP/IP extranet transport. It is a secure 168-bit encrypted transaction, using HTTPS.
Net Connect is a non-browser-based system requiring Experian certified client or vendor software at the user's location.
It utilizes XML for the input inquiry and has the capability of returning field-level XML, as well as our standard Automated
Response Format (ARF) (computer readable), Teletype Response Format (TTY) (human readable) and Parallel Profile
(both ARF and TTY in one response). Net Connect meets the encryption standards requirement in the Safeguards section of the
Gramm- Leach-Bliley (GLB) Act.

##### Net Connect includes:

1. A service to determine the correct URL for accessing Net Connect
2. Support for Experian’s Single Sign-On (SSO) service
3. Support for XML inquiries and response
4. Access to Experian's legacy systems from a single URL


## Installation

Add this line to your application's Gemfile:

    gem 'experian'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install experian

## Usage

TODO

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2013 Eric Hutzelman.
See [LICENSE][] for details.

[license]: LICENSE.txt
