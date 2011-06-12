class Note < ActiveRecord::Base

  set_table_name "Notes"
  requires_uuids :noteID

  belongs_to :case, :foreign_key => "ownerID"
  belongs_to :user, :foreign_key => "createdBy"

  default_scope order("createdOn asc")

  delegate :username, :to=>:user



end