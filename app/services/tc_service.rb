class TcService < Service

  def initialize(kase)
    @errors = []
    @case = kase
    @physician_location = @case.physician_location
    @driver = rpc_driver
  end

  def account_information_linked
    tc_account = process_response(*request_tc_account_linked){|response|
      response.merc_TcAccount
    }
    if tc_account.nil? then return false end
    physician_response = process_response(*request_physician_linked){|response|
      return nil if response.serviceResponse.nil?
      {:status=>response.serviceResponse.status, :message=>response.serviceResponse.message}
    }
    return nil if physician_response.nil?
    evaluate_response_status(physician_response[:status], physician_response[:message], "Export Physician")
  end

  def request_complete_case
    service_response = process_response(*complete_case){|response|
       return nil if response.serviceResponse.nil?
       {:status=>response.serviceResponse.status, :message=>response.serviceResponse.message}
    }
    return nil if service_response.nil?
    evaluate_response_status(service_response[:status], service_response[:message], "Defer TC Case")
  end

  private

  def complete_case
    timeout_request("TC Service : Complete Case"){
      @driver.DeferTcCase(:authenticationToken=>AUTH_TOKEN, :tpsCaseId=>@case.caseID)
    }
  end

  def request_physician_linked
    timeout_request("TC Service : Check Physician Linked"){
      @driver.ExportTpsPhysician(:tpsCaseId=>@case.caseID, :tpsPhysicianId=>@physician_location.physicianID)
    }
  end

  def request_tc_account_linked
    timeout_request("TC Service : Check TC Account Linked"){
      @driver.CheckTcAccountAvailable(:tpsAccountId=>@physician_location.accountID)
    }
  end

  def url
    case Rails.env
      when "development"
        return "http://devreport:9000/Export.asmx?WSDL"
      when "production"
        return "http://LabISReport:9000/Export.asmx?WSDL"
      when "test"
        return nil
    end
  end

end