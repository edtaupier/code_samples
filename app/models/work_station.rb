class WorkStation < ActiveRecord::Base

  set_table_name "WorkStations"
  
  after_find :format_uuids

  def self.current
    return Thread.current['workstation']
  end
  
  def self.current=(value)
    Thread.current['workstation'] = value
  end
  
  def self.get_embedding_work_stations
    return find_all_by_workStationTypeId(WorkStationType.embedding.workStationTypeId).collect{|s| [s.name, s.workStationId]}
  end

end
