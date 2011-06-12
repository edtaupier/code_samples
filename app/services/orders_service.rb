class OrdersService < Service

  def initialize(kase)
    @case = kase
    @errors = []
    @driver = rpc_driver
  end

  def request_case_has_orders
    process_response(*check_case_has_orders){|response|
      response.checkCaseHasOrdersResult
    }
  end

  def request_complete_order
    service_response = process_response(*complete_order){|response|
      return nil if response.serviceResponse.nil?
      {:status=>response.serviceResponse.status, :message=>response.serviceResponse.message}
    }
    return nil if service_response.nil?
    evaluate_response_status(service_response[:status], service_response[:message], "Complete Order")
  end

  private

  def url
    case Rails.env
      when "development"
        return "http://devreport:9001/Export.asmx?WSDL"
      when "production"
        return "http://LabISReport:9001/Export.asmx?WSDL"
      when "test"
        return nil
    end
  end

  def check_case_has_orders
    timeout_request("Order Service : Check Case Has Orders"){
      @driver.CheckCaseHasOrders(:tpsCaseId=>@case.caseID)
    }
  end

  def complete_order
    timeout_request("Order Service: Complete Order"){
      @driver.CompleteOrder(:tpsCaseId=>@case.caseID)
    }
  end

end