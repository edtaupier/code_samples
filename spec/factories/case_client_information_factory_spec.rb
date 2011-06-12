require 'spec_helper'

describe CaseClientInformationFactory do

  include TestFactory
  include CaseClientInformationFactory

  before :each do
    @case = new_object(Case, :caseID)
    stub_case_client_information
  end

  it "provides a method to gather client information related to a case" do
    set_client_information
    @account.should == @_account
    @location.should == @_location
    @physician.should == @_physician
    @physician_location.should == @_physician_location
    @address.should == @_address
  end

end