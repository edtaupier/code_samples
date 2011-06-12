class SpecimenTest < ActiveRecord::Base

  set_table_name "SpecimenTests"
  requires_uuids :specimenTestID
  
  has_many :printed_slide_records, :foreign_key=>"ownerID"
  belongs_to :lab_test, :foreign_key=>"testID"
  belongs_to :specimen, :foreign_key=>"specimenID"
  belongs_to :status, :foreign_key => "statusID"

  delegate :specimen_number, :to=>:specimen
  delegate :cpt_code, :to=>:lab_test


  def ihc_status
    if clinicalActivityID?
      return self.status || "Pending"
    end
    nil
  end


end
