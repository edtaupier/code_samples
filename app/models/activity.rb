class Activity < ActiveRecord::Base
  
  EMBEDDING_SOURCE_ID = '256B4151-0B10-4A05-83F3-131724EAD910'
  
  set_table_name "Activities"
  set_primary_key "activityID"  
  
  after_find :format_uuids
  
  before_create :assign_id
  
  belongs_to :specimen_block, :foreign_key=>"ownerID"
  
  scope :embedding, where(:activityTypeID=>ActivityType::EMBEDDING_TYPE_ID)
  
  def assign_id
    self.activityID = get_new_uuid
  end
  
  def self.create_new_embedding_activity(block)
    return Activity.create!(:ownerID=>block.specimenBlockID, :activityTypeID=>ActivityType.embedding.activityTypeID, :caseID=>block.case.caseID,
                    :description=>"Machine Info: #{WorkStation.current.name} #{WorkStation.current.serialNumber}", 
                    :createdOn=>DateTime.now, :createdBy=>User.current.userID, :lastUpdated=>DateTime.now,
                    :lastUpdatedBy=>User.current.userID, :sourceID=>EMBEDDING_SOURCE_ID, :dueDate=>DateTime.now, :assignedTo=>User.current.userID,
                    :categoryID=>ActivityCategory::CASE_CATEGORY_ID, :subcategoryID=>ActivityCategory::LAB_SUBCATEGORY_ID,
                    :statusID=>ActivityStatus::PENDING, :priorityID=>Priority::NORMAL)
  end
  
end

