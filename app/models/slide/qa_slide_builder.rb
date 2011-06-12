class Slide::QaSlideBuilder

  attr_reader :slide, :kase, :attributes, :parameters

  def initialize(parameters)
    @parameters = parameters
    @kase = Case.find(parameters[:caseId])
    set_attributes
    new_slide = Slide.create!(@attributes)
    update_case_identifier(@kase) if new_slide.valid?
    @slide = new_slide
  end

  def set_attributes
     @attributes = {:ownerID=>parameters[:specimenId],
                :label=>parameters[:label],
                :stain=>parameters[:stain],
                :number=>1, :identifier=>@kase.slideSeed,
                :createdOn=>DateTime.now, :createdBy=>User.current.userID,
                :lastUpdatedOn=>DateTime.now, :lastUpdatedBy=>User.current.userID}
  end

  def update_case_identifier(the_case)
    the_case.update_attribute(:slideSeed, the_case.slideSeed + 1)
  end


end