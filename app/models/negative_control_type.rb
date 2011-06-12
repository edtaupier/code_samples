class NegativeControlType < ActiveRecord::Base  

  set_table_name "NegativeControlTypes"
  set_primary_key "negativeControlTypeID"
  
  has_many :slides, :foreign_key=>"negativeControlTypeID"

end
