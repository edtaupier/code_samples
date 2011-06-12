require 'spec_helper'

describe QaManifestPresenter do
  include TestFactory

  before :each do
    @case = new_object(Case, :caseID)
    @start_date = DateTime.now
    @end_date = DateTime.now + 1.day
    stub_case_client_information
    Case.stub(:find).and_return(@case)
    Case.should_receive(:grossed_cases_for_location).with(@_location.locationID, @start_date.to_s, @end_date.to_s)
  end

  context "initialize presenter" do

    before :each do
       @slide_shipping_info = new_object(SlideShippingDetail, :slideShippingDetailsId)
       @_location.stub(:slide_shipping_detail).and_return(@slide_shipping_info)
       @presenter = QaManifestPresenter.new(@start_date.to_s, @end_date.to_s, @case.caseID, @_location.locationID)
    end

    it "accepts a start and end date to compare against the grossed date" do
      @presenter.should_not be_nil
      @presenter.start_date.to_s.should == @start_date.to_s
      @presenter.end_date.to_s.should == @end_date.to_s
    end

    it "gets the slide shipping info for the location" do
      @presenter.slide_shipping_info.should == @slide_shipping_info
    end

  end



  
end