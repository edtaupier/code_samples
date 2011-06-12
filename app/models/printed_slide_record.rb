class PrintedSlideRecord < ActiveRecord::Base
  
  set_table_name "PrintedSlideRecords"
  requires_uuids(:printedSlideRecordID)
  
  belongs_to :case, :foreign_key=>"caseID"
  belongs_to :specimen_test, :foreign_key=>"ownerID"
  has_many :slides, :foreign_key=>"ownerID"
  
  scope :completed, :joins=>:specimen_test
  scope :with_assoc, :include=>[:slides]

  delegate :specimen_number, :to=>:specimen_test
  
  
end

