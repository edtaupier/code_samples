class PhysicianLocation < ActiveRecord::Base
  set_table_name "PhysiciansLocations"
  requires_uuids(:physiciansLocationID)

  belongs_to :account, :foreign_key => "accountID"
  belongs_to :physician, :foreign_key => "physicianID"
  belongs_to :location, :foreign_key => "locationID"

  has_many :cases, :foreign_key => "physiciansLocationID"

end