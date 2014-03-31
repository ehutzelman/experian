module Experian
  module Constants

    LOOKUP_SERVLET_URL = "http://www.experian.com/lookupServlet1"
    ECALS_TIMEOUT = 86400 # 24 hours in seconds

    PASSWORD_RESET_URL = "https://ss3.experian.com/securecontrol/reset/passwordreset"
    
    PRECISE_ID_URL = "https://ss3.experian.com/fraudsolutions/xmlgateway/preciseid"
    PRECISE_ID_TEST_URL = "https://dm2.experian.com/fraudsolutions/xmlgateway/preciseid"

    LOOKUP_SERVICE_NAME = "AccessPoint"
    LOOKUP_SERVICE_VERSION = 1.0

    SERVICE_NAME = "NetConnect"
    SERVICE_NAME_TEST = "NetConnectDemo"

    SERVICE_VERSION = 2.0

    ARF_VERSION = "06"

    XML_NAMESPACE = "http://www.experian.com/NetConnect"
    XML_SCHEMA_INSTANCE = "http://www.w3.org/2001/XMLSchema-instance"
    XML_SCHEMA_LOCATION = "http://www.experian.com/NetConnect NetConnect.xsd"
    XML_REQUEST_NAMESPACE = "http://www.experian.com/WebDelivery"

    COMPLETION_CODES = {
      "0000" => "Request processed successfully",
      "1000" => "Invalid request format",
      "1001" => "Invalid length",
      "1002" => "Invalid length",
      "1003" => "No XML request",
      "1004" => "Invalid request parameter",
      "2000" => "Authorization failure",
      "4000" => "System error. Call Experian Technical Support at 1-800-854-7201."
    }

    ERROR_ACTION_INDICATORS = {
      "I" => "Informative",
      "C" => "Correct and/or resubmit",
      "R" => "Report condition or database problem",
      "S" => "Suspend"
    }

  end
end
