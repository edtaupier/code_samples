require 'spec_helper'

describe Case do

  include TestFactory

  context "specimens" do

    before :each do
      @case = new_object(Case, "caseID")
      @specimens = [new_object(Specimen, "specimenID", {:specimenNumber=>1}),
                    new_object(Specimen, "specimenID", {:specimenNumber=>3}),
                    new_object(Specimen, "specimenID", {:specimenNumber=>2})]
      @case.specimens = @specimens
    end

    it "gets sorted list of specimen numbers from case specimens" do
      list = @case.specimen_ids
      list[0].should == 1
      list[-1].should == 3
    end

  end


  context "slide identifier" do

    before :each do
      @kase = Case.new
      @physloc = double('physloc')
      @account = double('account')
      @physloc.stub(:account).and_return(@account)
      @kase.stub(:physician_location).and_return(@physloc)
      @kase.requisitionNumber = "req1234"
      @kase.hospitalLabId = "hospital1234"
      @kase.accessionNumber = "acc1234"
    end

    it "sets the identifier to req number" do
      @account.stub(:slideLabelIdentifierID).and_return(SlideIdentifier::REQUISITION_NUMBER)
      @kase.slide_identifier.should == @kase.requisitionNumber
    end

    it "sets the identifier to hospital id" do
      @account.stub(:slideLabelIdentifierID).and_return(SlideIdentifier::HOSPITAL_LAB_NUMBER)
      @kase.slide_identifier.should == @kase.hospitalLabId
    end

    it "defaults to the accession number" do
      @account.stub(:slideLabelIdentifierID).and_return(nil)
      @kase.slide_identifier.should == @kase.accessionNumber
    end

  end
  

end
