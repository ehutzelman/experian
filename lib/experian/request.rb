module Experian
  class Request
    attr_reader :xml

    def initialize(options = {})
      @options = options
      @xml = build_request
    end

    def build_request
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.instruct!(:xml, :version => '1.0', :encoding => 'utf-8')
      yield xml if block_given?
      xml.target!
    end

    def body
      xml
    end

    def headers
      { "Content-Type" => "text/xml" }
    end
  end
end
