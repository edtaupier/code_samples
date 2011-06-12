class ActivityType < ActiveRecord::Base
  
  set_table_name "ActivityTypes"
  set_primary_key "ActivityTypeID"
  
  after_find :format_uuids
  
  EMBEDDING_TYPE_ID = "F11927AE-3FDF-11E0-AC0B-000C299574C3"
  
  def self.embedding
    ActivityType.find_by_activityTypeID(EMBEDDING_TYPE_ID)
  end
  
end

