require 'spec_helper'

describe SpecimenBlock do

  include TestFactory
  
  before :all do
    @block = new_object(SpecimenBlock, "specimenBlockID")
    @specimen = new_object(Specimen, 'specimenID')
    @block.specimen = @specimen

    @user = new_object(User, "userID")
    User.current = @user
    
    @case = Case.new({:isLockedForQA=>true, :statusID=>""})
    
  end
  
  context "Initializing from scan" do
    
    before :all do
      
    end
    
    it "gets block from scan if it exists" do
      @scan = double('scan')
      @scan.stub(:scan_text).and_return(nil)
      SpecimenBlock.stub(:find_by_barcode).and_return(@block)
      existing_block = SpecimenBlock.get_or_create_specimen_block(@scan)
      existing_block.specimenBlockID.should == @block.specimenBlockID
    end
       
  end
  
 it "sets new block attributes" do
   @block.set_new_block_attributes
   @block.createdBy.should == @user.userID
   @block.specimenID.should == @specimen.specimenID
   @block.createdOn.should_not == nil
 end
 
 it "is invalid if the case is not found" do
   @block.case = nil
   @block.case_found?.should be_false
   @block.valid.should be_false
 end
 
 it "is invalid if the patient is not found" do
   @block.case = @case
   @block.case.patient = nil
   @block.case_has_patient?.should be_false
   @block.valid.should be_false
 end
 
 it "is invalid if the specimen is not found" do
   @block.specimen = nil
   @block.specimen_found?.should be_false
   @block.valid.should be_false
 end
 
 it "is invalid if embedding activity already completed" do
   @block.embedding_activity = Activity.new({:isComplete=>true})
   @block.already_embedded?.should be_true
   @block.valid.should be_false
 end
 
 it "is invalid if the case is locked for qa" do
   @block.case = @case
   @block.locked_for_qa?.should be_true
   @block.valid.should be_false
 end
 
 it "is invalid if the case is not grossed" do
   @block.grossed?.should be_false
   @block.valid.should be_false
 end
 
 it "is invalid if current block is block in progress" do
   @block.current_in_progress?(@block.specimenBlockID).should be_true
 end
 
end
