class Case < ActiveRecord::Base
  include Case::Queries

  set_table_name "Cases"
  requires_uuids(:caseID)
  
  belongs_to :patient, :class_name=>"ClinicalContact", :foreign_key=>"clinicalContactID"
  belongs_to :physician_location, :foreign_key => "physiciansLocationID"
  belongs_to :case_type, :foreign_key => "caseTypeID"
  belongs_to :status, :foreign_key => "statusID"

  has_many :specimens, :foreign_key=>"caseID"
  has_many :printed_slide_records, :foreign_key=>"caseID"
  has_many :specimen_tests, :through=>:specimens
  has_many :case_histories, :foreign_key => "caseID"
  has_many :notes, :foreign_key => "ownerID"

  delegate  :account, :to=>:physician_location
  delegate  :barcode_patient_name, :to=>:patient
  delegate :physician, :location, :to=>:physician_location
  delegate :description, :to=>:case_type
  delegate :description, :to=>:status, :prefix=>true, :allow_nil=>true

  def specimen_ids
    specimens.collect{|s| s.specimenNumber}.sort{|a,b| a<=>b}
  end

  def slide_identifier
    case account.slideLabelIdentifierID.to_s.upcase
      when SlideIdentifier::REQUISITION_NUMBER then return requisitionNumber
      when SlideIdentifier::HOSPITAL_LAB_NUMBER then return hospitalLabId
      else return accessionNumber
    end
  end

  def flag_for_qa(reason)
    update_attributes(:isLockedForQA=>true, :isQA=>true)
    QaReasonCase.create_qa_for_tc_import_fail(self, reason)
  end

  def self.qa_case(id)
    kase = Case.find(id)
    kase.specimens.includes(:bodysite, :specimen_type, :specimen_tests=>:lab_test)
    kase
  end

end

