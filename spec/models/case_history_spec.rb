require 'spec_helper'

describe CaseHistory do

  include TestFactory

  before :all do
    User.current = new_object(User, :userID)
  end

  context "saving qa slides" do

    before :each do
      @case = new_object(Case, :caseID)
      @history = History::Qa.create_qa_slides_edit_history(@case.caseID)
    end

    it "creates a case history for saving qa slides" do
      @history.caseID.should == @case.caseID
      @history.eventUserID.should == User.current.userID
      @history.eventTypeID.should == EventType::LAB_FLOW
      @history.statusID.should == Status::COMPLETED_ACTIVITY
      @history.description.should == "Slides edited in LabFlow QA center"
    end

  end


end