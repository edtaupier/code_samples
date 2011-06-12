require 'spec_helper'

describe "Completing a case using the orders service" do

  include TestFactory

  before :each do
    @case = new_object(Case, :caseID)
    Case.stub(:find).and_return(@case)
    @service = CompleteCase.new(@case.caseID)
    @order_service = OrdersService.new(@case)
    OrdersService.stub(:new).and_return(@order_service)
    @service.stub(:validate_case_status).and_return(true)
  end

  context "The order service times out" do

    before :each do
      @case.should_receive(:flag_for_qa).and_return(true)
      @order_service.stub(:check_case_has_orders).and_return([nil, "Orders Service timed out"])
      @service.complete_case
    end

    it "returns an error if the orders service times out" do
      @service.errors.include?("Orders Service timed out").should be_true
    end

  end

  context "The order service returns a failed status" do
    
    before :each do
      @case.should_receive(:flag_for_qa).and_return(true)
      @order_service.stub(:request_case_has_orders).and_return(true)
      @order_service.stub(:complete_order).and_return([{:complete_order_response=>{:service_response=>{:status=>'500', :message=>'Failed'}}}, nil])
      @service.complete_case
    end

    it "returns an error if the response code is not 200" do
      @service.errors.include?("Complete Order FAILED with status:500 and message:Failed").should be_true
    end

  end

  context "The order service returns a successful status (200)" do

    before :each do
      @order_service.stub(:request_case_has_orders).and_return(true)
      @order_service.stub(:complete_order).and_return([{:complete_order_response=>{:service_response=>{:status=>'200', :message=>'Success'}}}, nil])
      @service.should_receive(:mark_case_complete).and_return(true)
      @service.complete_case
    end

    it "completes successfully when the code is 200" do
      @service.errors.empty?.should be_true
    end
    
  end

end