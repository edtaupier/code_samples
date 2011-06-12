class QaReasonCase < ActiveRecord::Base

  set_table_name "QaReasonsCases"
  requires_uuids(:qaReasonsCaseId)

  belongs_to :case, :foreign_key => :caseId

  TC_IMPORT_FAIL = "631AC67B-2028-4115-9EA2-80195631691E"

  def self.create_qa_for_tc_import_fail(kase, message)
    create!(:qaReasonId=>TC_IMPORT_FAIL, :caseId=>kase.caseID, :resolution=>message,
            :createdOn=>DateTime.now, :createdBy=>User.current.userID, :lastUpdated=>DateTime.now,
            :lastUpdatedBy=>User.current.userID)
  end

end