class PhysicianSuffix < ActiveRecord::Base

  set_table_name "PhysiciansSuffixes"
  requires_uuids(:physicianSuffixID)

  belongs_to :physician, :foreign_key => "physicianID"
  belongs_to :suffix, :foreign_key => "suffixID"

  default_scope order("suffixOrder ASC")

end