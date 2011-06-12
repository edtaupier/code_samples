class SpecimenType < ActiveRecord::Base
  set_table_name "SpecimenTypes"
  requires_uuids :specimenTypeID
  
  has_many :specimens, :foreign_key=>"specimenTypeID"
  
  def to_s
    description
  end
  
end
