class Slide < ActiveRecord::Base
  
  set_table_name "Slides"
  requires_uuids(:slideID)

  belongs_to :lab_test, :foreign_key=>"testID"
  belongs_to :printed_slide_record, :foreign_key=>"ownerID"
  belongs_to :negative_control_type, :foreign_key=>"negativeControlTypeID"
  belongs_to :specimen, :foreign_key => "ownerID"

  scope :slides_with_assoc, lambda {|ids| {:conditions=>["Slides.slideID IN (?)", ids],
                              :include=>[{:printed_slide_record=>:specimen_test}, :specimen, :lab_test]}
  }

  scope :case_specimen_slides, lambda{|kase| {:conditions=>["Slides.ownerID IN (?)", kase.specimens.collect{|s| s.specimenID}],
                                 :include=>[:specimen]}}

  delegate :specimen_number, :body_site_description, :to=>:specimen, :allow_nil=>true
  delegate :specimen_number, :to=>:printed_slide_record, :prefix=>"printed_slide"

  def self.new_from_qa(parameters=nil)
    Slide::QaSlideBuilder.new(parameters).slide
  end

  def assign_id
    self.slideID = get_new_uuid
  end

  def printed_on
    createdOn || DateTime.now
  end

  def self.update_qa_slides(slides_params, caseId)
    return if slides_params.nil?
    slides_params.each do |id, attributes|
      Slide.update(id, attributes.reject{|k, v| k == 'print'})
    end
    History::Qa.create_qa_slides_edit_history(caseId)
  end

  def self.update_slides_for_print(slides_params, kase)
    update_qa_slides(slides_params, kase.caseID)
    slides = Slide.find(get_selected_for_print_ids(slides_params))
    History::Qa.create_qa_slides_printed_history(kase.caseID)
    SlideLabel.get_for_collection(slides, kase)
  end

  def self.get_selected_for_print_ids(slides_params)
    slides_params.find_all{|k, v| v['print'] == 'true'}.collect{|k, v| k}
  end
  
end
