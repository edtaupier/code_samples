class Slide::QaSlide
  
  attr_accessor :specimen, :specimen_test, :slide, :specimen_number, :body_site_description, :stain, :label

  delegate :slideID, :to=>:slide

  def initialize(specimen_test, slide)
    @slide = slide
    @specimen_test = specimen_test
    set_specimen
    @specimen_number = @specimen.specimenNumber
    @body_site_description = @specimen.body_site_description
    set_label
    set_stain
  end

  def self.get_slides_for_case(kase)
    return(slides_for_printed_slide_record(kase) + slides_for_case_specimens(kase))
  end

  private

  def set_label
    if @slide.label? then @label = @slide.label and return end
    if @specimen_test then @label = @specimen_test.partNumber and return end
    ""
  end

  def set_specimen
    if @specimen_test
      @specimen = @specimen_test.specimen
    else
      @specimen = @slide.specimen
    end
  end

  def set_stain
    if(@slide.stain?)
      @stain = @slide.stain
    elsif(@slide.labelName?)
      @stain = @slide.labelName
    elsif(@slide.negativeControlTypeID?)
      @stain = @slide.negative_control_type.description
    elsif(@slide.lab_test)
      @stain =@slide.lab_test.abbreviation
    else
      @stain = ""
    end
  end

  def self.slides_for_printed_slide_record(kase)
    qa_slides = []
    for record in kase.printed_slide_records.with_assoc
      for slide in record.slides
        qa_slides << Slide::QaSlide.new(record.specimen_test, slide)
      end
    end
    qa_slides
  end

  def self.slides_for_case_specimens(kase)
    qa_slides = []
    for slide in Slide.case_specimen_slides(kase)
      qa_slides << Slide::QaSlide.new(nil, slide)
    end
    qa_slides
  end
  
end
