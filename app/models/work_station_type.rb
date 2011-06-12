class WorkStationType < ActiveRecord::Base
  
  set_table_name "WorkStationTypes"
  
  after_find :format_uuids
  
  def self.embedding
    return find_by_description("Embedding")
  end

end
