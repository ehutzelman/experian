module Experian
  module PreciseId
    class PrimaryRequest < Request
      
      def add_request_content(xml)
        xml.tag!('XMLVersion', "5.0")
        add_subscriber(xml)
        add_applicant(xml)
        xml.tag!('Verbose', "Y") if @options[:verbose]
        add_vendor(xml)
        add_options(xml)
      end

      def add_subscriber(xml)
        xml.tag!('Subscriber') do
          xml.tag!('Preamble', Experian.preamble)
          xml.tag!('OpInitials', Experian.op_initials)
          xml.tag!('SubCode', Experian.subcode)
        end
      end

      def add_applicant(xml)
        xml.tag!('PrimaryApplicant') do
          xml.tag!('Name') do
            xml.tag!('Surname', @options[:last_name])
            xml.tag!('First', @options[:first_name])
          end
          add_current_address(xml)
        end
      end

      def add_current_address(xml)
        xml.tag!('CurrentAddress') do
          xml.tag!('Street', @options[:street])
          xml.tag!('City', @options[:city])
          xml.tag!('State', @options[:state])
          xml.tag!('Zip', @options[:zip])
        end if @options[:zip]
      end

      def add_vendor(xml)
        xml.tag!('Vendor') do
          xml.tag!('VendorNumber', Experian.vendor_number)
        end
      end

      def add_options(xml)
        xml.tag!('Options') do
          xml.tag!('PreciseIDType', "21")
          xml.tag!('ReferenceNumber', "XML PROD OP 19") if @options[:reference_number]
          xml.tag!('DetailRequest', "D") if @options[:detail_request]
          xml.tag!('InquiryChannel', "INTE") if @options[:inquiry_channel]
        end
      end
    end
  end
end
