require 'spec_helper'


describe CompleteCase do

  include TestFactory

  before :each do
    @case = new_object(Case, :caseID)
  end

  context "case is locked for qa" do

    before :each do
      @case.isLockedForQA = true
      call_service
    end

    it "is invalid when the case is locked for qa" do
      @result.should be_false
      @service.errors.include?("Case is locked for QA").should be_true
    end

  end

  context "case is not in eligible status" do

    it "is invalid if in ordered status" do
      @case.statusID = Status::ORDERED
      call_service
      @service.errors.include?("Cannot complete case in current status").should be_true
    end

    it "is invalid if in deleted status" do
      @case.statusID = Status::DELETED
      call_service
      @service.errors.include?("Cannot complete case in current status").should be_true
    end

    it "is invalid if in accessioned status" do
      @case.statusID = Status::ACCESSIONED
      call_service
      @service.errors.include?("Cannot complete case in current status").should be_true
    end

    it "is invalid if in pending accession status" do
      @case.statusID = Status::PENDING_ACCESSION
      call_service
      @service.errors.include?("Cannot complete case in current status").should be_true
    end

  end


  def call_service
    Case.should_receive(:find).with(@case.caseID).and_return(@case)
    @service = CompleteCase.new(@case.caseID)
    @result = @service.complete_case
  end


end