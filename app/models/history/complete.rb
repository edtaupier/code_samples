class History::Complete < ActiveRecord::Base

  set_table_name "CaseHistories"
  requires_uuids :caseHistoryID

  belongs_to :case, :foreign_key => :caseID

  class << self

    def create_case_completed_history(kase)
      create!(:caseID=>kase.caseID, :eventTypeID=>EventType::LAB_FLOW,
              :eventTimestamp=>DateTime.now, :eventUserID=>User.current.userID,
              :statusID=>kase.statusID, :description=>"Case Completed")
    end

  end

end