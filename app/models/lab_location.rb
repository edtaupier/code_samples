class LabLocation < ActiveRecord::Base
  set_table_name "LabLocations"
  set_primary_key "labLocationid"
  
  after_find :format_uuids
  
  def self.current
    return Thread.current[:location]
  end
  
  def self.current=(value)
    Thread.current[:location] = value
  end
  
  def self.login_list
    all.collect{|l| [l.displayName, l.labLocationid]}
  end   
  
end
