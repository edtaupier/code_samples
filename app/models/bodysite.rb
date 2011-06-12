class Bodysite < ActiveRecord::Base 

  set_table_name "Bodysites"
  set_primary_key "bodysiteID"
  
  has_many :specimens, :foreign_key=>"bodysiteID"

  def body_site_description
    self.description
  end

  def sanitized_body_site_description
    self.description.gsub("(", " - ").gsub(")", "")
  end

end
