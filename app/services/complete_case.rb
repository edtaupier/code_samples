class CompleteCase

  attr_reader :errors, :case, :case_id, :has_order
  
  def initialize(case_id)
    @errors = []
    @case_id = case_id
  end

  def complete_case
    return false if !validate_case(case_id)

    status = complete_case_order
    if status.nil? then @case.flag_for_qa(@order_service.errors) and return status end
    mark_case_complete and return true if status == true

    status = complete_tc_case
    if status.nil? then @case.flag_for_qa(@tc_service.errors) and return status end
    mark_case_complete and return true if status == true or status == false
    nil
  end

  private

  def complete_tc_case
    @tc_service = TcService.new(@case)
    case @tc_service.account_information_linked
      when true, "true"
        return true if @tc_service.request_complete_case
        @errors += @tc_service.errors and return nil
      when nil
        @errors += @tc_service.errors
        return nil
      when false, "false"
        return false
    end
    nil
  end

  def complete_case_order
     @order_service = OrdersService.new(@case)
     case @order_service.request_case_has_orders
       when true, "true"
         return true if @order_service.request_complete_order
         @errors += @order_service.errors and return nil
       when nil
         @errors += @order_service.errors
         return nil
     end
     false
  end

  def mark_case_complete
    @case.update_attributes(:billingTypeID=>BillingType::HELD_BY_PATHOLOGIST,
                            :processedAt=>LabLocation.current.labLocationid,
                            :statusID=>Status::COMPLETED_CASE)
    History::Complete.create_case_completed_history(@case)
  end

  def validate_case(case_id)
    @case = Case.find(case_id)
    return false if !validate_case_qa_status
    validate_case_status
  end

  def validate_case_qa_status
    if @case.isLockedForQA?
      @errors << "Case is locked for QA"
      return false
    end
    true
  end

  def validate_case_status
    if Status::COMPLETE_CASE_RESTRICTED_STATUSES.include?(@case.statusID.upcase)
      @errors << "Cannot complete case in current status"
      return false
    end
    true
  end
  
end