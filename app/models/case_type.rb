class CaseType < ActiveRecord::Base

  set_table_name "CaseTypes"
  requires_uuids(:caseTypeID)

  has_many :cases, :foreign_key => "caseTypeID"

end