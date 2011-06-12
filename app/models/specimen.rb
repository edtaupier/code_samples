class Specimen < ActiveRecord::Base
  set_table_name "Specimens"
  requires_uuids(:specimenID)
  
  belongs_to :case, :foreign_key=>"caseID"
  belongs_to :specimen_type, :foreign_key=>"specimenTypeID"
  has_many :specimen_blocks, :foreign_key=>"specimenID"
  belongs_to :bodysite, :foreign_key=>"bodysiteID"
  has_many :specimen_tests, :foreign_key=>"specimenID"
  has_many :slides, :foreign_key => "ownerID"

  scope :number_order, order("specimenNumber")

  delegate :body_site_description, :sanitized_body_site_description, :to=>:bodysite
  delegate :description, :to=>:specimen_type, :prefix=>true

  alias_attribute :specimen_number, :specimenNumber
  alias_attribute :number, :specimenNumber

  def specimen_number=(val)
    self.specimenNumber = val
  end

  def self.cases_count(kase)
    count_by_sql("Select count(*) from Specimens where specimens.caseID = '#{kase.caseID}'")
  end

end
