class CaseHistory < ActiveRecord::Base

  set_table_name "CaseHistories"
  requires_uuids :caseHistoryID

#  skip_time_zone_conversion_for_attributes << :eventTimestamp

  belongs_to :case, :foreign_key=>"caseID"
  belongs_to :user, :foreign_key=>"eventUserID"

  alias_attribute :logged, :eventTimestamp

  delegate :username, :to=>:user

  default_scope order("eventTimestamp DESC")

end