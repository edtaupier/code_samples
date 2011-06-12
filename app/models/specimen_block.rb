class SpecimenBlock < ActiveRecord::Base
  set_table_name "SpecimenBlocks"
  set_primary_key "specimenBlockID"

  attr_accessor :cassette_scan, :case, :patient, :valid, :specimen, :error_message, :embedding_activity
  attr_protected :specimenBlockID, :specimenID
  
  before_create :assign_id
  after_find :format_uuids, :get_embedding_activity
  
  belongs_to :specimen, :foreign_key=>"specimenID"
  has_many :activities, :foreign_key=>"ownerID"
  
  def assign_id
    self.specimenBlockID = get_new_uuid
  end
  
  def get_embedding_activity
    @embedding_activity = activities.embedding.first
  end

  def self.initialize_from_scan(scan, current_block_id)
    block = get_or_create_specimen_block(scan)
    block.valid = true
    block.cassette_scan = scan
    block.case = Case.find_by_accessionNumber(block.cassette_scan.accession_number)
    if block.cassette_scan.specimen_number.blank? then block.cassette_scan.specimen_number = assign_specimen_number(block) end
    block.specimen = Specimen.find_by_caseID_and_specimenNumber(block.case.caseID, block.cassette_scan.specimen_number) unless !block.case
    block.embedding_activity = block.activities.embedding.first
    block.get_case_from_scan(current_block_id)
  
    if block.valid && block.new_record?
      block.set_new_block_attributes
      block.save
    end
    return block
  end
  
  def self.get_or_create_specimen_block(scan)
    return SpecimenBlock.find_by_barcode(scan.scan_text) || 
            SpecimenBlock.new(:barcode=>scan.scan_text)
  end
  
  def self.assign_specimen_number(block)
    if !block.case then return nil end
    if block.case.specimens.length == 1 then return 1 end
    return nil
  end
  
  def set_new_block_attributes
    self.specimenID = self.specimen.specimenID
    self.createdBy = User.current.userID
    self.createdOn = DateTime.now
  end
  
  def get_case_from_scan(current_block_id)
    if !case_found? then return end
    if !case_has_patient? then return end
    if !specimen_found? then return end
    if already_embedded? then return end
    if locked_for_qa? then return end
    if !grossed? then return end
    if current_in_progress?(current_block_id) then return end
  end
  
  def current_in_progress?(current_block_id)
    if self.specimenBlockID == current_block_id
      self.valid = false
      self.error_message = "This block is already in progress."
    end
    return !self.valid
  end
  
  def grossed?
    if self.case.statusID.upcase != Status::GROSSED
      self.valid = false
      self.error_message = "This case has not yet been grossed.  Embedding cannot be done at this time."
    end
    return self.valid
  end
  
  def locked_for_qa?
    if self.case.isLockedForQA?
      self.valid = false
      self.error_message = "The case for this block is currently locked for QA.  Embedding cannot be done at this time."
    end
    return !self.valid
  end
  
  def case_has_patient? 
    self.patient = self.case.patient
    if !self.patient
      self.valid = false
      self.error_message = "Patient information does not exist for this case.  Embedding cannot be done at this time."
    end
    return self.valid
  end
  
  def case_found?
    if !self.case 
      self.valid = false
      self.error_message = "The case could not be located for the cassette you entered."
    end
    return self.valid
  end
  
  def specimen_found?
    if !self.specimen
      self.valid = false
      self.error_message = "Specimen information could not be found for this case.  Embedding cannot be done at this time."
    end
    return self.valid
  end
  
  def already_embedded?
    if self.embedding_activity && self.embedding_activity.isComplete?
      self.valid = false
      self.error_message = "Embedding has been marked as completed for this block."
    end
    return !self.valid
  end
  
  def begin_embedding_activity
    if !self.embedding_activity
      self.embedding_activity = Activity.create_new_embedding_activity(self)
    end
  end

  def self.find_and_complete_embedding(blockId)
    block = find(blockId)
    block.complete_embedding
    return block
  end
  
  def complete_embedding 
    self.embedding_activity.update_attributes(:isComplete=>true, :lastUpdated=>DateTime.now,
                                              :lastUpdatedBy=>User.current.userID, :statusID=>ActivityStatus::COMPLETE)
  end
  
end 

