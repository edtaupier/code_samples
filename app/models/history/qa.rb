class History::Qa < ActiveRecord::Base

  set_table_name "CaseHistories"
  requires_uuids :caseHistoryID

  belongs_to :case, :foreign_key => "caseID"

  class << self

    def create_qa_slides_edit_history(caseID)
      create_qa_slide_history(caseID, "Slides edited in LabFlow QA center")
    end

    def create_qa_slides_printed_history(caseID)
      create_qa_slide_history(caseID, "Slides labels printed in LabFlow QA center")
    end

    private

    def create_qa_slide_history(caseID, description)
      create!(:caseID=>caseID, :eventTypeID=>EventType::LAB_FLOW,
              :eventTimestamp=>DateTime.now, :eventUserID=>User.current.userID,
              :statusID=>Status::COMPLETED_ACTIVITY, :description=>description)
    end


  end

end