class SlideShippingDetail < ActiveRecord::Base

  set_table_name "SlideShippingDetails"
  requires_uuids :slideShippingDetailsID

  belongs_to :location, :foreign_key => :ownerId

end