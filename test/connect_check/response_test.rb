require 'test_helper'

describe Experian::ConnectCheck::Response do

  describe "successful response" do
    before do
      stub_experian_request("connect_check", "response.xml")
      @response = Experian::ConnectCheck.check_credit(first_name: "Homer", last_name: "Simpson", ssn: "123456789")
    end

    it "parses out defined segments into array" do
      assert_equal 22, @response.segments.count
    end

    it "returns a specific segment" do
      assert_equal "12500220603PRTBPPCTQQ", @response.segment(125)
    end

    it "receives a successful response" do
      assert @response.success?
      refute @response.error?
    end

    it "extracts the credit match code" do
      assert_equal "C", @response.credit_match_code
    end

    it "maps the credit match code message" do
      assert_equal "ID Match", @response.credit_match_code_message
    end

    it "extracts the credit class code" do
      assert_equal "3", @response.credit_class_code
    end

    it "extracts the credit score" do
      assert_equal 603, @response.credit_score
    end

    it "extracts the high risk address alert" do
      assert_equal "X", @response.high_risk_address_alert
    end

    it "extracts the credit fraud code" do
      assert_equal "Z", @response.credit_fraud_code
    end

    it "extracts the input type" do
      assert_equal "S", @response.input_type
    end

    it "extracts the customer name" do
      assert_equal "AMBLE,ROBERT", @response.customer_name
    end

    it "extracts the customer message" do
      assert_equal "Fraud alert on account. Deposit required to complete enrollment.", @response.customer_message
    end

    it "extracts the statement type code" do
      assert_equal 6, @response.statement_type_code
      @response.customer_names
    end

    it "extracts the customer name aliases" do
      assert_includes @response.customer_names, "ROBERT K AMBLE"
    end

    it "extracts the customer addresses" do
      assert_includes @response.customer_addresses, "6717 11TH AVE  /BROOKLYN NY 112195904"
    end
  end

  describe "error response" do
    before do
      stub_experian_request("connect_check", "response_error_legacy.xml")
      @response = Experian::ConnectCheck.check_credit(first_name: "Homer", last_name: "Simpson", ssn: "123456789")
    end

    it "receives an error response" do
      refute @response.success?
      assert @response.error?
    end

    it "extracts the error code" do
      assert_equal 45, @response.error_code
    end

    it "extracts the error action indicator" do
      assert_equal "C", @response.error_action_indicator
    end

    it "translates the error action indicator message" do
      assert_equal "Correct and/or resubmit", @response.error_action_indicator_message
    end

    it "maps an error message based on code" do
      assert_equal "Experian: Error Code 45", @response.error_message
    end
  end

end
